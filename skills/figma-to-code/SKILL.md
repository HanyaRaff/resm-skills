---
name: figma-to-code
description: MANDATORY whenever the user gives a figma.com link or Figma node id and wants it built, matched, fixed or "made like the design". Explains how to make the build pixel-precise (read values, never guess) and how to prove it (render the real component, compare screenshots, measure the DOM against Figma numbers) before saying it is done.
---

# Precise Figma → code (look AND logic), and how to test it

Rule zero: **you are not done until you have looked at the Figma screenshot AND a screenshot of
your own build, and measured the parts that matter.** "It should look right" is not a test.

**Work folder:** save every screenshot, compare page and the Chrome profile in
`C:/Users/USER/AppData/Local/Temp/figma-check/` (create it with `mkdir -p` first). Never save them
inside the project. Delete the whole folder when the work is done (step 12).

## The pipeline (follow in order, do not skip steps)

```
 1. PARSE LINK      figma.com/design/<fileKey>/...?node-id=1-2  →  fileKey, nodeId "1:2"
        │           (branch URL → use branchKey as fileKey)
        ▼
 2. SESSION         create_session(fileKey, task) → reuse sessionId on every Figma call
        │
        ▼
 3. MAP THE FRAME   get_metadata(node) → layer tree + x/y/w/h; list every frame & state to build
        │
        ▼
 4. PULL DESIGN     per frame/section:  get_design_context  +  get_screenshot  (+ get_variable_defs)
        │           save each screenshot as C:/Users/USER/AppData/Local/Temp/figma-check/figma-<frame>.png
        ▼
 5. SPEC TABLE      write values per element (size, spacing, type, colour, border, shadow)
        │           flag values that don't match tokens / the typography guide
        ▼
 6. LOOK IN CODE    find the existing page/component, tokens, reusable components, icons
        │           + READ THE EXISTING LOGIC fully: data loading, store, API calls, emits,
        │             routes, permissions; read the backend route/controller for the API shape
        ▼
 6b. LOGIC PLAN     behaviour table for every interactive element + data map + the states the
        │           design does not draw (loading, empty, error, locked, long data)  (Part L)
        ▼
 7. BUILD           implement with project tokens; keep existing props/emits/API behaviour
        │
        ▼
 8. RENDER          throwaway harness + headless Chrome screenshot at each Figma frame width
        │           → C:/Users/USER/AppData/Local/Temp/figma-check/build-<frame>.png
        ▼
 9. COMPARE         side by side + difference overlay (B2)
        │
        ▼
10. MEASURE         --dump-dom geometry/computed styles vs get_metadata numbers (B3), ±1px
        │
        ▼
10b. TEST LOGIC     run every row of the behaviour table + every state (B6); no console errors;
        │           eslint clean on changed files; npm run build passes
        │
        ├── differences? ──► fix ──► back to 8
        ▼
11. CHECKLIST       B4 all ticked (states, responsive tiers, long/empty data)
        │
        ▼
12. CLEAN UP        delete tmp-<name>.html and src/tmp-<name>/, ALL screenshots
        │           (figma-*.png, build-*.png, compare.html/png), the chrome-profile folder,
        │           and close your Chrome profile only
        │
        ▼
13. REPORT          what was built, what was compared, remaining differences + why (Part C)
```

Parts below explain each step: A = steps 3–5 and 7 (look), L = steps 6–6b (logic),
B = steps 8–12 (testing look AND logic), C = step 13.

---

## Part A — Getting the design precise

### A1. Collect the source of truth (never work from memory or a description)

For every frame you implement (desktop, laptop, tablet, mobile, and each state: empty, filled,
hover, error, modal open…):

1. `get_metadata` on the frame → the layer tree with x, y, width, height of every node. Use it to
   find the child nodes and to get exact positions.
2. `get_design_context` on the frame (or on each big child if the frame is large) → exact values:
   padding, gap, radius, border width/colour, fill, shadow, font family/size/weight/line-height,
   letter spacing, auto-layout direction and alignment.
3. `get_screenshot` on the same node → what is actually visible. Save it; you will compare against it.
4. `get_variable_defs` if values come from Figma variables, so you can map them to project tokens.

If context and screenshot disagree (hidden layer, clipped content, overridden component), the
screenshot decides what is visible; the context decides the exact numbers.

### A2. Write a spec table before coding

Turn the data into a short table per section, e.g.:

| Element      | Size / box        | Spacing                 | Type                  | Colour / border        |
|--------------|-------------------|-------------------------|-----------------------|------------------------|
| Card         | w fill, h hug     | p 24, gap 16            | —                     | bg white, r 16, 1px N-20 |
| Card title   | —                 | —                       | 20/28 semibold        | N-90                   |
| Stat chip    | h 28              | px 12, gap 6            | 14/20 medium          | bg coral-10, text coral-70 |

This forces you to read every value instead of eyeballing. Note anything odd (e.g. 18px text where
the type scale has 16) as a discrepancy to report, not to silently copy.

### A3. Translate Figma layout to CSS 1:1

- Auto-layout horizontal/vertical → `flex` / `flex-col`; "space between" → `justify-between`;
  item spacing → `gap-*`; padding → `p-*` exactly as given.
- "Fill container" → `flex-1` / `w-full`; "Hug contents" → no fixed size; "Fixed" → explicit size.
- Absolute-positioned layers → `absolute` with the offsets from `get_metadata`.
- Line height matters as much as font size; always set both.
- Borders: Figma inside strokes do not add size; use `box-border` and check heights.
- Shadows: copy x, y, blur, spread, colour+opacity exactly.
- Images: check the crop mode (fill → `object-cover`, fit → `object-contain`) and the radius.
- Text: check truncation/wrapping in the screenshot (`truncate`, `line-clamp-*`, `whitespace-nowrap`).

### A4. Map to the project's design system (precise ≠ hardcoded)

- Use existing tokens: colours, radius, spacing and the typography tokens. Find the token whose
  value equals the Figma value. If the Figma value matches no token, prefer the nearest guide token
  for typography (the typography guide wins over a single frame) and mention it in one line.
- Reuse existing components before building new ones; search the codebase first.
- Icons: use the icon library the project already uses (here Phosphor `<PhName />`, preferring the
  icon the existing code already uses for that action). Export only real illustrations.

### A5. Responsive

Implement each Figma frame at its tier and check the in-between widths too:

| Figma frame | Tier    | Tailwind | Range           |
|-------------|---------|----------|-----------------|
| 1600        | desktop | `ml`     | ≥ 1280          |
| 1280        | laptop  | `lg`     | 1024 – 1279     |
| 768         | tablet  | `ss`     | 600 – 1023      |
| 390         | mobile  | base     | < 600           |

---

## Part L — Logic: the design is a picture, the feature is behaviour

A Figma frame shows ONE moment with FAKE data. Building only what is drawn gives a page that looks
right but does nothing, or breaks with real data. Copying the design is half the job; the other half
is the behaviour. Do this before writing the template (pipeline step 6b).

### L1. Read the existing logic first

If you are redesigning an existing page or component, read the old file completely, not just the
template. List every behaviour it has: what it loads and when, store usage, API calls (method,
URL, payload), watchers, emits, props, route/query params, permission or plan checks, toasts,
confirm prompts, redirects. **The new design must keep every one of them** unless the user said to
remove it. Losing an old feature because the new design "didn't show it" is a bug.

Also read the backend side (route + controller + validation) for each API the page uses, so you
know the real response fields, the validation rules and the error format.

### L2. Behaviour table (write it down, like the spec table)

For every button, link, input, toggle, tab, menu item, card and row action in the design:

| Element          | Trigger | What happens (API / store / route)      | While busy        | On success                 | On error             | Disabled / hidden when   |
|------------------|---------|-----------------------------------------|-------------------|----------------------------|----------------------|--------------------------|
| "Simpan" button  | click   | PUT /api/x {fields}                     | spinner, disabled | toast, refresh data, close | field errors + toast | form invalid / not dirty |
| Delete row icon  | click   | PromptModal confirm → DELETE /api/x/:id | row loading       | remove row, update counts  | toast, row stays     | no permission            |
| Search input     | type    | debounced 300ms filter / API query      | —                 | list updates, page → 1     | keep old list        | —                        |

Every row must end up implemented and tested. If you can't fill a cell (no API exists, unclear
rule), that is a question for the user, not something to invent or skip silently.

### L3. Data map — nothing hardcoded that should be dynamic

Map every visible text, number, image and badge in the design to its source: API field, store,
prop, computed value, or i18n string. Figma placeholder content ("John Doe", "120 Tamu",
"12 Des 2026", Lorem ipsum, sample photos) is NEVER shipped as-is.

- Counts and totals come from data (computed), not typed in.
- Format dates, currency, numbers and plurals with the project's existing helpers/locale.
- Handle null/missing fields (no photo → placeholder, no name → fallback text).
- Static labels follow the project's text/i18n convention, matching nearby code.

### L4. States the design usually doesn't draw

Implement each one, reusing the pattern existing pages already use:

- **Loading** — first load (skeleton/spinner) and per-action loading.
- **Empty** — no data yet, and no search results (different messages).
- **Error** — failed load with a retry; failed action without losing the user's input.
- **Locked / no permission / feature not in plan.**
- **Partial data** — missing image, null field, zero values.
- **Big data** — long names/text, many items (pagination, scroll, truncation).
- **Double actions** — double click, submitting twice, switching tabs mid-request.
- **Leaving with unsaved changes** where the page has a form.

If the design is missing a state, follow the existing app pattern and list it as an assumption
in the report.

### L5. Forms

- Initial values come from the API; "dirty" is compared against them.
- Validation matches the backend rules (required, max length, format, min/max).
- Backend validation errors are shown on the right field.
- Trim inputs; disable submit while saving; prevent double submit.
- After success: update the local data/store (or refetch), reset dirty state, give feedback.

### L6. Where logic goes (code quality)

- Follow the patterns already in the project: existing stores (`src/stores`), composables
  (`src/composables`), utils, constants files. Don't create a new pattern when one exists.
- Keep templates simple: move conditions and formatting into computed properties.
- One source of truth per value; prefer `computed` over `watch` + copied state.
- Clean up listeners, timers and intervals in `onUnmounted`.
- No leftover `console.log`, commented-out code or unused imports.
- If you change a shared component, grep its other usages and make sure they still work.

### L7. When design and logic disagree

The design shows a button/field the backend doesn't support, or the API has data the design
doesn't show → don't fake it and don't drop it silently. Ask the user, or build what you can and
list the gap clearly in the report.

---

## Part B — Testing that it matches

### B1. Render the REAL component

Do not judge from code. Render it:

1. Make sure the dev server runs (`curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/`).
2. Create a throwaway harness: `tmp-<name>.html` at the project root and `src/tmp-<name>/main.js`
   + `Wrapper.vue`. `main.js` copies the app setup from `src/main.js` (Pinia, PrimeVue with the same
   preset/pt/ptOptions/cssLayer, router/i18n if needed, global resolvers, the same CSS imports).
   `Wrapper.vue` mounts the real component with realistic fake props/data (real-length names,
   long text, empty lists, many rows — whatever the Figma frame shows).
   In the html head add:
   ```html
   <style>*{transition:none!important;animation:none!important}</style>
   <script>addEventListener("resize", e => e.stopImmediatePropagation(), true)</script>
   ```
3. Screenshot with headless Chrome at the Figma frame width:
   ```sh
   "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" --headless=new --disable-gpu \
     --no-first-run --user-data-dir="C:/Users/USER/AppData/Local/Temp/figma-check/chrome-profile" --hide-scrollbars \
     --window-size=1600,1200 --virtual-time-budget=20000 \
     --screenshot="C:/Users/USER/AppData/Local/Temp/figma-check/build-1600.png" http://127.0.0.1:3000/tmp-<name>.html
   ```
   - Pages that load audio/video: use `--timeout=10000` instead of `--virtual-time-budget`.
   - Phone widths (Chrome won't lay out below ~500px): screenshot a second html that contains
     `<iframe src="/tmp-<name>.html" style="width:390px;height:852px;border:0">`.
   - States (modal open, dropdown open, hover, error): trigger them from `Wrapper.vue` on mount
     with `await nextTick()` loops, not `setTimeout`.

### B2. Visual comparison (side by side + overlay)

Open both PNGs and compare section by section (header, each card, table, footer). For a sharper
check, build a compare page and screenshot it:

```html
<!-- C:/Users/USER/AppData/Local/Temp/figma-check/compare.html -->
<body style="margin:0;display:flex;gap:16px;background:#888">
  <img src="figma.png" style="width:800px">
  <img src="build.png" style="width:800px">
  <div style="position:relative;width:800px">
    <img src="figma.png" style="width:800px;position:absolute">
    <img src="build.png" style="width:800px;position:absolute;mix-blend-mode:difference">
  </div>
</body>
```

In the difference panel, matching areas go black; anything bright is a mismatch (offset text,
wrong colour, wrong size). Make sure both images are the same scale (Figma screenshots may be 2x).

### B3. Measure, don't eyeball

For the key elements, dump real geometry and compare with the `get_metadata` numbers:

```js
// in Wrapper.vue onMounted, after await nextTick()
const pick = { card: '.card', title: '.card h3', chip: '.stat-chip' }
const out = {}
for (const [k, sel] of Object.entries(pick)) {
  const el = document.querySelector(sel); if (!el) { out[k] = 'MISSING'; continue }
  const r = el.getBoundingClientRect(), s = getComputedStyle(el)
  out[k] = { x: r.x, y: r.y, w: r.width, h: r.height, font: `${s.fontSize}/${s.lineHeight} ${s.fontWeight}`,
             color: s.color, bg: s.backgroundColor, pad: s.padding, gap: s.gap, radius: s.borderRadius }
}
document.body.insertAdjacentHTML('beforeend', `<pre id="dbg">${JSON.stringify(out, null, 1)}</pre>`)
```

Run Chrome with `--dump-dom` instead of `--screenshot` and read the `#dbg` block.
**Tolerance:** sizes and positions within 1px, colours exact (token value), font size/weight/line
height exact (or the guide token, if you deliberately followed the guide).

### B4. Checklist before reporting done

- [ ] Every frame/state from the link rendered and compared
- [ ] Spacing (padding, gaps, margins) within 1px
- [ ] Typography: size, weight, line height, colour, wrapping/truncation
- [ ] Colours, borders, radius, shadows
- [ ] Icons: correct icon, size, colour, alignment
- [ ] Images: crop and radius
- [ ] Responsive: each tier + one width between tiers, no horizontal scroll
- [ ] Long/empty data doesn't break the layout
- [ ] Existing behaviour (props, emits, API calls) still works — every item from L1
- [ ] Every row of the behaviour table (L2) implemented and tested, success and error
- [ ] No Figma placeholder data shipped; every value comes from data (L3)
- [ ] Loading, empty, error, locked and long-data states implemented and screenshotted (L4)
- [ ] Forms: validation, backend errors, no double submit (L5)
- [ ] No console errors or Vue warnings; eslint clean on changed files; `npm run build` passes
- [ ] Harness files deleted; only Chrome processes using the figma-check chrome-profile were killed
- [ ] All screenshots and compare files deleted once the work is done

### B4b. Delete the screenshots when finished

After the final comparison passes (and before reporting), remove every image and helper you made:

```sh
WORK="C:/Users/USER/AppData/Local/Temp/figma-check"
rm -f  "$WORK"/figma-*.png "$WORK"/build-*.png \
       "$WORK"/compare.html "$WORK"/compare*.png
rm -rf "$WORK"   # removes the chrome-profile and anything left
rm -f  tmp-<name>.html && rm -rf src/tmp-<name>/
```

Also check that no screenshot ended up inside the project folder (`git status` should show no
`.png` you created). Never leave screenshots in the repo.

### B6. Test the logic, not only the look

1. **Behaviour table:** go through every row from L2. In the harness, trigger the action from
   `Wrapper.vue` (`await nextTick()` loops) and dump the result into `#dbg`, or test the real
   page in the running app against the dev backend. Check the request (URL, method, payload) and
   what the UI does on success AND on error.
2. **States:** feed the component each L4 state (loading, empty, error, long data, null fields,
   no permission) through props or a mocked API response, and screenshot each one.
3. **Console:** no errors and no Vue warnings (missing props, unknown components, failed
   requests). Write `window.onerror` and `app.config.warnHandler` output into `#dbg` and read it
   with `--dump-dom`.
4. **Old behaviour:** re-check every item listed in L1 still works.
5. **Static checks:** `npx eslint <changed files>` with no new errors, and `npm run build` passes.
   Run `npm run test:unit` if tests exist for that area.

### B5. Fix loop

List each difference → fix → re-render → compare again. Repeat until the only differences left are
intentional ones (e.g. typography guide over frame value).

---

## Part C — Report honestly

Also list: the behaviour table rows you tested, the states you added that the design did not
draw, any logic assumptions, and any design-vs-backend gaps (L7).

Tell the user: what was built, which screenshots/measurements you compared, and every remaining
difference with its reason. If you could not render or measure (server down, auth, missing data),
say so plainly. Never claim "matches the design" without B1–B3.

## Project notes (this repo)

- Type/colour tokens: `src/styles/app.css` (`--text-*` per breakpoint), exposed via `tailwind.config.js`.
- PrimeVue: `:pt` must be an object of sections, never a function; `mergeProps` concatenates
  classes, so use `!` on conflicts; tabs get a default 2px bottom border (`!border-0` for pills);
  body-appended overlay menus can look offset in headless captures, verify via the DOM dump.
- Confirm/delete prompts use `src/Components/Modals/PromptModal.vue`.
- No Figma node ids in code comments.
