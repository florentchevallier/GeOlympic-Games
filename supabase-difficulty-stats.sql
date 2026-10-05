-- Aggregated difficulty votes for GeOlympic Games, readable by everyone.
-- Run once in the Supabase SQL editor. difficulty_votes itself stays
-- private (each player only reads their own row); this function exposes only
-- the per-series average and vote count. Until it is installed, the series
-- cards simply show the author's difficulty rating alone.

create or replace function public.difficulty_stats()
returns table(mode_key text, avg_rating numeric, votes int)
language sql
security definer
set search_path = public
as $$
  select v.mode_key, round(avg(v.rating)::numeric, 2), count(*)::int
  from public.difficulty_votes v
  group by v.mode_key;
$$;

grant execute on function public.difficulty_stats() to anon, authenticated;
