<p align="center">
  <img src="art/geolympic_banner.png" alt="GeOlympic Games — guess the place from its real relief" width="800">
</p>

<p align="center"><em>Guess the place from its real relief — no labels, no place names, just terrain.</em></p>

**Version:** 0.2 (prototype)
**Live demo:** [Click here to play](https://florentchevallier.github.io/GeOlympic-Games/)

---

## Concept

Most "guess the place" games rely on the same crutch: a labelled map, a flag, or a
street-level photo. GeOlympic Games strips that away and asks a different question —
*can you recognize a place from nothing but its topography?*

Every round shows a circular window onto a real, unlabeled relief map (or, in one
mode, the rotated silhouette of an island's true coastline) and asks you to name the
place. Difficulty is controlled by how much of the terrain you get to see — the
hardest view is a tight 50 km circle around a city or island with no wider context,
and each wrong guess automatically zooms out to a wider (and easier) view, at the
cost of points.

The project grew out of a simple test: does reading a mountain range, a coastline, or
an island's outline actually work as a recognition game the way a flag or a photo
does? A few iterations in, it does — and different kinds of terrain (mountain-locked
cities, coastal cities, islands) turned out to need genuinely different game
mechanics, which is why they're split into separate series rather than one shared
pool of places.

## Game modes

| Mode | What you see | How you answer |
|---|---|---|
| **Mountain cities** | Real shaded relief, zoomed circle, no coastline to lean on | Multiple choice or typed answer |
| **Coastal cities** | Real shaded relief including shoreline, bays, deltas | Multiple choice or typed answer |
| **Islands — silhouette (easy)** | The island's full outline, rotated to a random angle | Multiple choice or typed answer, single guess |
| **Islands — relief (hard)** | Same zoomed-circle mechanic as cities, applied to islands | Multiple choice or typed answer |

For islands large enough to have more than one distinct landscape (Sumatra, Java,
Borneo, New Guinea, Luzon, Mindanao, Hokkaido, Sicily, Antarctica), the relief mode
picks randomly each round between a few hand-picked viewpoints — some inland and
mountainous, some nearer the coast — instead of always centring on the same fixed
point. At the end of an island-relief round, the map zooms out to reveal the island's
full outline before moving on.

Islands that would make the puzzle trivial — where the island's shape *is* the
country's shape (Australia, Greenland), or when the name of the island is less known
or too generic (New Zealand / Aotearoa, with its North and South Island) — are
deliberately excluded. Antarctica and individual islands of multi-island nations
(Indonesia, the Philippines) are kept in, since recognizing *which* one is still a
real challenge. Same with multi-nation islands (**Borneo**, split between Indonesia,
Malaysia and Brunei; **New Guinea**, split between Indonesia and Papua New Guinea) —
those stay in too.

## Rules

- A session is **8 rounds**, worth **1000 points** total (125 per round max).
- Each round: **100 base points** (scaled down if you needed to zoom out to find the
  answer) **+ 25 speed points** if you answer within the time window.
- The speed window is **5 seconds** by default, or **3 seconds** in hard-timer mode
  (choosable before each session; typed-answer mode always uses 5 seconds).
- A wrong guess in relief mode zooms out one level automatically instead of ending
  the round — you can still recover, but for fewer points.
- In Multiple Choice mode, city options show the country's flag rather than its name,
  for a faster read; islands show the name only (a flag wouldn't reliably identify a
  multi-country island anyway).
- Optional hint, available only in typed-answer mode: a country flag (half points) for
  city/island-silhouette modes, or an extra forced zoom-out for a flat 10-point cost
  in the hard island mode.
- No place repeats within the same 8-round session.

## Technology

Single self-contained HTML file — no build step, no backend, no framework.

- **[MapLibre GL JS](https://maplibre.org/)** renders the map, using a custom
  **[MapTiler](https://www.maptiler.com/)** style built specifically for this game
  (real hillshade and hypsometric colouring, tuned for readability rather than the
  muted look of a generic basemap). MapTiler's attribution badge stays visible on the
  map itself, as required by their terms.
- **Real island geometry**, not hand-drawn: outlines were extracted from
  [Natural Earth](https://www.naturalearthdata.com/) boundary data (via the
  [`world-atlas`](https://github.com/topojson/world-atlas) / `topojson-client`
  npm packages, 50 m resolution), then simplified to ~60-70 points per island.
  Multi-country islands (Borneo, New Guinea) are extracted from the physical
  landmass outline rather than a single country's polygon, so the shape isn't
  truncated at a border.
- **Azimuthal equidistant projection**, computed locally in JS and centred on each
  island's own coordinates, for the silhouette mode — a flat lon/lat projection
  distorts shapes badly near the poles, which matters for Antarctica.
- No mapping data is fetched at runtime beyond the map tiles themselves; all place
  data (coordinates, island outlines) is embedded directly in the file.

## Data & attribution

- Map style and tiles: **[MapTiler](https://www.maptiler.com/)**, built on
  **OpenStreetMap** data — credited live on the map via MapLibre's own attribution
  control, which reads it straight from the style.
- Island boundary geometry: **Natural Earth**, via `world-atlas`.
- Mapping library: **[MapLibre GL JS](https://maplibre.org/)**.

## Status & next steps

This is an early, functional prototype built to validate the core mechanic before
investing further in content and polish. Known limitations:

- Place data (cities, islands) is hardcoded in the HTML; a future version should load
  it from separate GeoJSON files instead, especially once the list grows.
- Only a handful of places per series so far — more are planned per mode, plus
  additional series (rivers, and a "bathymetry only, no land/sea distinction" expert
  mode).
- For multi-country islands, the single country-flag hint is a simplification (it
  names one country only, even though the island itself isn't one country's alone).
- The banner image lives in `/art` rather than being embedded in the HTML file, so
  opening the game file on its own (outside the repo) will show alt text instead of
  the banner — a deliberate trade-off now that the game is hosted via GitHub Pages
  rather than meant to be a fully offline, single-file download.

## Running it

Just open the HTML file in a browser — the game itself is fully self-contained (the
banner image is the one exception, see above). It is also available
[on GitHub Pages](https://florentchevallier.github.io/GeOlympic-Games/). Have fun!
