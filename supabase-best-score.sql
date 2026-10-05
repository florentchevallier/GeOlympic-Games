-- Atomic "keep the best score" for GeOlympic Games.
-- Run once in the Supabase SQL editor. Until it is installed the game falls
-- back to a read-then-write that two devices could race on.
--
-- Assumes best_scores has a unique key on (user_id, mode_key), which the
-- game's existing upsert already relies on. Returns true when the submitted
-- score became the new best.

create or replace function public.submit_best_score(p_mode_key text, p_score int)
returns boolean
language plpgsql
security invoker
as $$
declare
  n int;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  if p_score < 0 then
    raise exception 'invalid score';
  end if;

  insert into public.best_scores (user_id, mode_key, score, achieved_at)
  values (auth.uid(), p_mode_key, p_score, now())
  on conflict (user_id, mode_key) do update
    set score = excluded.score, achieved_at = excluded.achieved_at
    where public.best_scores.score < excluded.score;

  get diagnostics n = row_count;
  return n > 0;
end;
$$;

grant execute on function public.submit_best_score(text, int) to authenticated;
