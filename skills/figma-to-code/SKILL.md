---
name: figma-to-code
description: MANDATORY whenever the user gives a figma.com link or Figma node id and wants it built, matched, fixed or "made like the design". Explains how to make the build pixel-precise (read values, never guess), how to keep and plan the logic (not only the look), and how to prove both (render the real component in Chrome, compare screenshots, measure the DOM against Figma numbers) before saying it is done.
---

# Precise Figma → code (look AND logic), and how to test it

Rule zero: **you are not done until you have looked at the Figma image AND a screenshot of your
own build, measured the parts that matter, and run the behaviour.** "It should look right" is not a test.

## Tools in this setup

- **Figma** (`figma` MCP server, Framelink `figma-developer-mcp`):
  - `get_figma_data(fileKey, nodeId)`: layout, sizes, fills, strokes, effects, text styles, component
    info. Do not pass `depth` unless the frame is too big; then fetch child nodes one by one instead.
  - `download_figma_images(fileKey, nodes:[{nodeId, fileName}], localPath, pngScale)`: exports a node
    as PNG/SVG. **Exporting the whole frame node as PNG is your Figma screenshot.** `localPath` must be
    RELATIVE to the server's image directory (absolute paths outside it are refused). Use
    `localPath: "figma-check"`, then read the saved path from the tool result. Use `pngScale: 1` for
    screenshots so they compare 1:1 with the browser (default is 2). Nodes with an image fill need
    `imageRef` from `get_figma_data`.
- **Browser** (`chrome-devtools-mcp`): `new_page` / `navigate_page`, `resize_page`, `take_screenshot`
  (with `filePath`, `fullPage`), `take_snapshot` (gives element uids), `click`, `fill`, `hover`,
  `evaluate_script` (returns JSON: use it to measure), `list_console_messages`, `list_network_requests`.
- **Shell**: PowerShell on Windows. Use PowerShell syntax (no `rm -rf`, `/dev/null`, `&&` in 5.1).
- **Docs**: use Context7 for library/API questions (PrimeVue, Tailwind, Vue).

**Work folder:** everything you create for checking (Figma images, build screenshots, compare page)
goes in `C:\Users\USER\AppData\Local\Temp\figma-check\` (move the Figma PNGs there from wherever
`download_figma_images` saved them). Never leave them in the project. Delete the folder at the end.

## Pipeline (in order, no skipping)

1. **Parse link**: `figma.com/design/<fileKey>/<name>?node-id=1-2` → fileKey, nodeId `1:2`
   (branch URL `.../design/<fileKey>/branch/<branchKey>/...` → use branchKey as fileKey).
2. **Pull design**: `get_figma_data` per frame + `download_figma_images` of the same frame at
   `pngScale: 1`. Do this for EVERY frame you build (desktop/laptop/tablet/mobile) and every state shown.
   - Variants of one component (colour/state/category): full data for ONE; for the others note only
     what differs.
   - Data and image disagree (hidden layer, clipped content) → the image decides what is visible,
     the data decides the numbers.
3. **Spec table**: per element: size, spacing (padding/gap), type (size/line-height/weight/letter
   spacing), colour, border, radius, shadow. Flag values that match no token: the typography guide
   wins over a single frame; say so in one line, don't ask.
4. **Read the code**: the existing page/component completely (template AND script), tokens, reusable
   components, icons, and the backend route/controller of every API it uses.
5. **Logic plan** (Part L): behaviour table, data map, undrawn states. Write it down before coding.
6. **Build** with project tokens and components; keep every existing behaviour.
7. **Render, compare, measure, test behaviour** (Part B); fix and repeat.
8. **Checks**: eslint on changed files each loop; `npm run build` once, at the end.
9. **Clean up** and **report** (Part C).

## Part A: translating the design

- Auto-layout → `flex`/`flex-col`; item spacing → `gap-*`; padding exact; space-between → `justify-between`.
- Fill → `flex-1`/`w-full`; Hug → no size; Fixed → explicit size; absolute layers → `absolute` + offsets.
- Always set line-height together with font size. Inside strokes don't add size (`box-border`).
- Shadows: x, y, blur, spread, colour + opacity exactly. Images: fill → `object-cover`, fit → `object-contain`.
- Text: copy wrapping/truncation (`truncate`, `line-clamp-*`, `whitespace-nowrap`).
- Use existing tokens and components first. Icons: Phosphor `<PhName />` (`@phosphor-icons/vue`),
  preferring the icon existing code already uses for that action. Export only real illustrations
  (`download_figma_images`, into `public/media/icon/retro/rebrand/` named `ic-<name>`); never hotlink
  temporary Figma image URLs.
- Responsive tiers: Figma 1600 → `ml` (≥1280), 1280 → `lg` (1024–1279), 768 → `ss` (600–1023),
  390 → base (<600). Don't use `xl`/`xxl` as device tiers.

## Part L: logic (the design is one moment with fake data)

Copying the design is half the job. A page that looks right but loses behaviour, or breaks with real
data, is not done.

- **Keep old behaviour**: list everything the old file does (what it loads and when, store, API
  method/URL/payload, watchers, emits, props, route/query params, permissions, toasts, confirm prompts,
  redirects). Every item must still work. Losing one because "the design didn't show it" is a bug.
- **Behaviour table**: for every button, link, input, toggle, tab, menu item and row action:

  | Element | Trigger | API / store / route | While busy | On success | On error | Disabled/hidden when |
  |---------|---------|---------------------|------------|------------|----------|----------------------|
  | "Simpan" | click | PUT /api/x {fields} | spinner, disabled | toast, refresh, close | field errors + toast | invalid / not dirty |

  A cell you can't fill is a question for the user, not an invention.
- **Data map**: every visible text/number/image comes from API, store, prop, computed or i18n. Figma
  placeholder content ("John Doe", "120 Tamu", Lorem ipsum, sample photos) never ships. Use the
  project's date/number/currency helpers; handle null/missing fields.
- **States the design doesn't draw**: loading, empty (no data vs no search results), error with retry,
  locked/no permission/not in plan, partial data, long/big data, double submit, unsaved changes. Follow
  existing app patterns and list them as assumptions in the report.
- **Forms**: initial values from the API; validation matching the backend rules; backend errors on the
  right field; trim; no double submit; after success update the data and reset the dirty state.
- **Code**: follow existing stores (`src/stores`), composables (`src/composables`), utils and constants;
  `computed` over `watch` + copied state; clean up listeners and timers in `onUnmounted`; no
  `console.log`, dead code or unused imports; grep other usages before changing a shared component.
- **Design vs backend gap**: don't fake it and don't drop it silently: ask, or build what you can and report it.

## Part B: testing look and logic

### B1. Render the real component

1. Dev server up? `(Invoke-WebRequest http://127.0.0.1:3000/ -UseBasicParsing).StatusCode` → 200.
   If not, ask the user or start `npm run dev` in the background.
2. Throwaway harness (keep it under `src/` so Tailwind scans it):
   - `tmp-<name>.html` at the project root:
     ```html
     <!doctype html><html><head><meta charset="utf-8">
     <style>*{transition:none!important;animation:none!important}</style>
     </head><body><div id="app"></div>
     <script type="module" src="/src/tmp-<name>/main.js"></script></body></html>
     ```
   - `src/tmp-<name>/main.js`: copy the setup from `src/main.js` (Pinia, PrimeVue with the same
     preset / `pt` / `ptOptions` / `cssLayer`, router and i18n if needed, ToastService,
     `installGlobalResolvers(app)`, the same CSS imports). Re-read `src/main.js` each time; it changes.
   - `src/tmp-<name>/Wrapper.vue`: mounts the REAL component with realistic data (long names, empty
     lists, many rows). Read `location.search` to switch variants/states without new files.
   - Alternative: test the real page in the running app (`http://127.0.0.1:3000/<route>`) if the user
     is logged in in that browser and the backend runs.
3. In Chrome (devtools MCP): `new_page` → `navigate_page` to `http://127.0.0.1:3000/tmp-<name>.html`
   → `resize_page` to the Figma frame width (1600, 1280, 768) → `take_screenshot` with
   `filePath: C:\Users\USER\AppData\Local\Temp\figma-check\build-1600.png` (`fullPage: true` if taller).
   Phone width (390): if the window won't go that narrow, open a second tmp html that iframes the
   harness at `width:390px;height:852px` and screenshot that.
4. States (modal open, dropdown, error, hover): trigger them with `click` / `fill` / `hover` (uids from
   `take_snapshot`), or from `Wrapper.vue` via query params.

### B2. Compare

Look at the Figma PNG and your build screenshot side by side, section by section (header, each card,
table, footer). Both must be the same scale (Figma at `pngScale: 1`). For a sharper check, make
`figma-check\compare.html` with both images side by side plus an overlay where the build image has
`mix-blend-mode:difference` on top of the Figma image (matching areas go black, mismatches light up),
open it with `navigate_page` (`file:///C:/Users/USER/AppData/Local/Temp/figma-check/compare.html`) and
screenshot it.

### B3. Measure, don't eyeball

Use `evaluate_script` to read real geometry and styles, then compare with the `get_figma_data` numbers:

```js
() => {
  const pick = { card: '.card', title: '.card h3', chip: '.stat-chip' }   // your selectors
  const root = document.querySelector('#app').getBoundingClientRect()
  const out = {}
  for (const [k, sel] of Object.entries(pick)) {
    const el = document.querySelector(sel)
    if (!el) { out[k] = 'MISSING'; continue }
    const r = el.getBoundingClientRect(), s = getComputedStyle(el)
    out[k] = { x: r.x - root.x, y: r.y - root.y, w: r.width, h: r.height,
      font: `${s.fontSize}/${s.lineHeight} ${s.fontWeight}`, color: s.color, bg: s.backgroundColor,
      pad: s.padding, gap: s.gap, radius: s.borderRadius, border: s.border, shadow: s.boxShadow }
  }
  return out
}
```

Tolerance: ±1px for size and position, exact colours, exact type (or the guide token you chose).

### B4. Test the logic

- Run every behaviour-table row with `click` / `fill`, then check `list_network_requests` (URL, method,
  payload, status) and what the UI shows on success AND on error.
- Feed each undrawn state (loading, empty, error, long data, null fields, no permission) through props,
  query params or a mocked response, and screenshot each one.
- `list_console_messages` (types error and warn): no errors and no Vue warnings.
- Re-check every old behaviour you listed in Part L.

### B5. Fix loop

List the differences → fix → re-render → compare and measure again, until only intentional ones remain
(e.g. the typography guide over a frame value).

### B6. Checklist before reporting

- [ ] Every frame/state rendered, compared and measured
- [ ] Spacing within 1px; typography, colours, borders, radius, shadows, icons, image crops correct
- [ ] Responsive: each tier + one in-between width, no horizontal scroll
- [ ] Long/empty data holds; no Figma placeholder data shipped
- [ ] Every behaviour-table row tested (success and error); every old behaviour still works
- [ ] Loading/empty/error/locked states implemented and screenshotted
- [ ] No console errors or Vue warnings
- [ ] `npx eslint <changed files>` clean; `npm run build` passes
- [ ] Clean-up done (B7)

### B7. Clean up (always, before reporting)

```powershell
Remove-Item -Recurse -Force "C:\Users\USER\AppData\Local\Temp\figma-check" -ErrorAction SilentlyContinue
Remove-Item -Force "tmp-<name>.html" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "src\tmp-<name>" -ErrorAction SilentlyContinue
git status --short
```

Also delete any `figma-check` folder `download_figma_images` created elsewhere, and close the pages you
opened (`close_page`). `git status` must show no screenshots or tmp files.

## Part C: report

What was built; what was compared and measured; remaining differences and why; behaviour rows tested;
states added that the design didn't draw; logic assumptions; design-vs-backend gaps. If you couldn't
render, measure or test something, say so plainly. Never claim "matches the design" without
render + compare + measure.
