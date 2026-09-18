<p align="center">
  <img src="art/geolympic_banner.png" alt="GeOlympic Games — guess the place from its real relief" width="800">
</p>

<p align="center"><em>Guess the place from its real relief — no labels, no place names, just terrain.</em></p>

**Version:** 0.4.5 (prototype)
**Live demo:** [Click here to play](https://florentchevallier.github.io/GeOlympic-Games/)

---

## Concept

Most "guess the place" games rely on the same crutch: a labelled map, a flag, or a
street-level photo. GeOlympic Games strips that away and asks a different question —
*can you recognize a place from nothing but its topography?*

Every round shows a circular window onto a real, unlabeled relief map (or, in one
mode, the rotated silhouette of an island's true coastline, or a pannable patch of
open sea) and asks you to name the place. Difficulty is controlled by how much of the
terrain you get to see.

The project grew out of a simple test: does reading a mountain range, a coastline, or
an island's outline actually work as a recognition game the way a flag or a photo
does? A few iterations in, it does — and different kinds of terrain (mountain-locked
cities, coastal cities, islands, open seas) turned out to need genuinely different
game mechanics, which is why they're split into separate series with their own rules
rather than one shared pool of places.

## Game modes

| Mode | What you see | How you answer |
|---|---|---|
| **Mountain cities** (13 places) | Real shaded relief, zoomed circle, no coastline to lean on | Multiple Choice or typed answer |
| **Coastal cities** (14 places) | Real shaded relief including shoreline, bays, deltas | Multiple Choice or typed answer |
| **Islands — silhouette (easy)** (21 places) | The island's full outline, rotated to a random angle | Multiple Choice or typed answer, single guess |
| **Islands — relief (hard)** (21 places) | Same zoomed-circle mechanic as cities, applied to islands | Multiple Choice or typed answer |
| **Seas** (12 places) | A close-up, pannable patch of a real bathymetric map — drag to explore, can't zoom out beyond a couple of assisted steps | Multiple Choice or typed answer, unlimited guesses |

Places span every inhabited continent, from well-known cases (Chicago, Hong Kong,
Cuba) to more distinctive picks chosen specifically for how well their terrain reads
(Sarajevo, Bogotá, Sulawesi). For islands large enough to have more than one distinct
landscape, the relief mode picks randomly each round between a few hand-picked
viewpoints instead of always centring on the same fixed point. At the end of an
island-relief round, the map zooms out to reveal the island's full outline.

Islands that would make the puzzle trivial — where the island's shape *is* the
country's shape and universally recognisable (Australia, Greenland), or where the
name is less known or too generic (New Zealand / Aotearoa) — are deliberately
excluded. Antarctica, individual islands of multi-island nations, and a handful of
island-nations whose *shape* is still a real challenge to recognise (Sri Lanka, Cuba,
Taiwan, Madagascar) are kept in. Multi-country islands (Borneo, New Guinea) stay too.

**Seas** deliberately avoids the obvious ones (no Mediterranean-as-a-whole, no North
Sea) in favour of its sub-basins and lesser-known seas — Adriatic, Tyrrhenian,
Ligurian, Ionian, Aegean, Molucca, Banda, Sulu, Celebes, Sea of Okhotsk, Baltic,
Caribbean. Each sea's real boundary was hand-drawn in QGIS (5-16 vertices per
polygon) rather than approximated, and that polygon drives both the round's starting
view and the hard limit on how far the player can pan.

## Rules

**Mountain / coastal cities, islands — relief:**
- A session is **8 rounds**, worth **1000 points** total (125 per round max).
- Each round: **100 base points** (scaled down if you needed to zoom out to find the
  answer) **+ 25 speed points** if you answer within the time window.
- The speed window is **5 seconds** by default, or **3 seconds** in hard-timer mode
  (choosable before each session; typed-answer mode always uses 5 seconds).
- A wrong guess zooms out one level automatically instead of ending the round.
- In Multiple Choice, city options show the country's flag rather than its name, for
  a faster read; islands show the name only.
- Optional hint, typed-answer mode only: a country flag (half points) for cities/
  island-silhouette, or an extra forced zoom-out for a flat 10-point cost for islands.

**Islands — silhouette:** single guess, no timer; 100 points, halved if the flag hint
was used.

**Seas:** no timer, no automatic zoom-out. Instead: drag to pan (bounded to the sea's
real drawn limits — a red flash and vignette warn when you hit the edge), with two
assisted zoom-outs available per round and a button to reset to the starting view.
Wrong guesses don't end the round — score starts at 100 and drops by 20 per wrong
attempt (floor 20) until you get it or run out of options.

- No place repeats within the same 8-round session, in any mode.

## Technology

Single self-contained HTML file — no build step, no backend, no framework.

- **[MapLibre GL JS](https://maplibre.org/)** renders the map, switching at runtime
  between two custom **[MapTiler](https://www.maptiler.com/)** styles: a terrain/
  hillshade style for cities and islands, and a dedicated bathymetric style for seas.
  MapTiler's attribution badge stays visible on the map, as required by their terms.
  Terrain rounds run in MapLibre's **globe projection** (avoids Mercator's pole
  distortion — matters for Antarctica); seas rounds run in plain **Mercator**, since
  globe projection's pan-boundary math has known rough edges that made the sea's
  drawn limits unreliable to enforce.
- **Background tile prefetching**: while one round is being played, the game silently
  drives a second, invisible map instance to the *next* round's location, warming the
  browser's tile cache so the real view appears instantly instead of costing a fast
  player part of their speed-bonus window.
- **Real island and sea geometry**, not freehand guesses. Island outlines: extracted
  from [Natural Earth](https://www.naturalearthdata.com/) boundary data (via
  [`world-atlas`](https://github.com/topojson/world-atlas)/`topojson-client`, 50 m
  resolution). Multi-country islands (Borneo, New Guinea) are extracted from the
  physical landmass outline rather than a single country's polygon, so the shape
  isn't truncated at a border. Sea limits: hand-drawn in QGIS, sourced as GeoJSON.
- **Azimuthal equidistant projection**, computed locally in JS, for the island
  silhouette mode — a flat lon/lat projection distorts shapes badly near the poles.
- No mapping data is fetched at runtime beyond the map tiles themselves; all place
  data (coordinates, island/sea geometry) is embedded directly in the file.
- **Debug browser** (add `?debug` to the URL): steps through every place in every
  series, name shown, with direct access to each zoom level, each alternate
  viewpoint, and free panning — built to catch bad viewpoints or badly-drawn sea
  limits without having to play full sessions to spot them.

## Data & attribution

- Map styles and tiles: **[MapTiler](https://www.maptiler.com/)**, built on
  **OpenStreetMap** data — credited live on the map via MapLibre's own attribution
  control, which reads it straight from the style.
- Island boundary geometry: **Natural Earth**, via `world-atlas`.
- Sea boundary geometry: hand-drawn.
- Mapping library: **[MapLibre GL JS](https://maplibre.org/)**.

## Status & next steps

This is an early, functional prototype built to validate the core mechanics before
investing further in content and polish. Known limitations:

- Place data is hardcoded in the HTML; a future version should load it from separate
  GeoJSON files instead, especially once the list grows further.
- For multi-country islands, the single country-flag hint is a simplification.
- The banner image lives in `/art` rather than being embedded in the HTML file, so
  opening the game file on its own (outside the repo) will show alt text instead of
  the banner — a deliberate trade-off now that the game is hosted via GitHub Pages
  rather than meant to be a fully offline, single-file download.
- Seas mode's round-start view is centred on each sea's real polygon centroid with a
  small random jitter (not a fully random point in its bounding box), specifically so
  it doesn't start the player looking at land — worth revisiting if a sea's shape is
  narrow enough that even the centroid sits close to shore.

## Running it

Just open the HTML file in a browser — the game itself is fully self-contained (the
banner image is the one exception, see above). It is also available
[on GitHub Pages](https://florentchevallier.github.io/GeOlympic-Games/). Have fun!
