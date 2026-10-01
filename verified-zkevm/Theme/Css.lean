namespace VerifiedZkEvmSite

/-!
The site stylesheet.

Two rules keep the page structure from drifting:

* **Only cards are panels.** Bordered, padded surfaces belong to `.track-tile`, `.resource-card`,
  `.grant-card` — never to the `<article>` or `<section>` elements that
  Verso generates around page content, which nest and would otherwise stack concentric boxes.
* **Headings are sized by context, not by level.** A heading inside a card is sized by the card
  class, so the Lean side can pick whatever level keeps the document outline gap-free without
  affecting how anything looks.
-/
def siteCss : String :=
r#"
:root {
  --vz-page: #0a0d0b;
  --vz-surface: rgba(18, 23, 21, 0.7);
  --vz-surface-strong: #1a221f;
  --vz-ink: #e2e8e5;
  --vz-heading: #c4ded2;
  --vz-muted: #83958c;
  --vz-border: #222d28;
  --vz-accent: #0f9f90;
  --vz-accent-soft: #3fcabc;
  --vz-accent-rgb: 15, 159, 144;
  --vz-forest: #3c7062;
  --vz-max: 76rem;
  --vz-radius: 1rem;

  --verso-text-color: #e2e8e5;
  --verso-code-color: #3fcabc;
  --verso-structure-color: #c4ded2;
  --verso-selected-color: #222d28;
}

* {
  box-sizing: border-box;
}

html {
  scroll-behavior: smooth;
}

body {
  margin: 0;
  background:
    radial-gradient(circle at top left, rgba(var(--vz-accent-rgb), 0.08), transparent 32rem),
    radial-gradient(circle at bottom right, rgba(60, 112, 98, 0.1), transparent 36rem),
    var(--vz-page);
  color: var(--vz-ink);
  font-family: "IBM Plex Sans", sans-serif;
  line-height: 1.7;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

/* ---------- Typography ---------- */

h1, h2, h3, h4 {
  color: var(--vz-heading);
  font-family: "Source Serif 4", serif;
  line-height: 1.15;
  margin: 0 0 0.6em;
}

h1 {
  font-size: clamp(2rem, 4vw, 3rem);
  color: #ffffff;
}

h2 {
  font-size: clamp(1.5rem, 2.2vw, 2rem);
}

h3 {
  font-size: 1.25rem;
}

p, ul, ol, blockquote, pre {
  margin: 0 0 1rem;
}

ul, ol {
  padding-left: 1.35rem;
}

li {
  margin-bottom: 0.35rem;
}

/* Verso wraps every list item's text in a <p>; without this each item gains a full
   paragraph's worth of trailing space and lists read as though double-spaced. */
li > p {
  margin-bottom: 0;
}

li > p + p,
li > ul,
li > ol {
  margin-top: 0.35rem;
}

a {
  color: var(--vz-accent-soft);
  text-decoration-thickness: 0.08em;
  text-underline-offset: 0.16em;
  transition: color 0.2s ease;
}

a:hover {
  color: #52a692;
}

:focus-visible {
  outline: 2px solid var(--vz-accent-soft);
  outline-offset: 3px;
  border-radius: 4px;
}

code {
  font-family: monospace;
  font-size: 0.95em;
  background: rgba(255, 255, 255, 0.05);
  padding: 0.1em 0.3em;
  border-radius: 4px;
  color: var(--vz-accent-soft);
}

blockquote {
  border-left: 4px solid var(--vz-accent-soft);
  margin-left: 0;
  padding: 0.2rem 0 0.2rem 1rem;
  color: var(--vz-muted);
  background: rgba(255, 255, 255, 0.02);
}

hr {
  border: 0;
  border-top: 1px solid var(--vz-border);
  margin: 2rem 0;
}

img {
  max-width: 100%;
  height: auto;
}

/* ---------- Frame ---------- */

.site-header {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(12px);
  background: rgba(10, 13, 11, 0.9);
  border-bottom: 1px solid var(--vz-border);
}

.site-header__inner,
.site-shell,
.site-footer__inner {
  width: min(var(--vz-max), calc(100vw - 2rem));
  margin: 0 auto;
}

.site-header__inner {
  min-height: 4.5rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.site-mark {
  display: inline-flex;
  align-items: center;
  gap: 0.8rem;
  color: var(--vz-heading);
  font-weight: 700;
  text-decoration: none;
  letter-spacing: 0.01em;
}

.site-mark img {
  width: 2rem;
  height: 2rem;
}

.site-main {
  flex: 1;
  padding: 2rem 0 4rem;
}

.site-footer {
  border-top: 1px solid var(--vz-border);
  padding: 1.5rem 0;
  color: var(--vz-muted);
  font-size: 0.92rem;
}

.site-footer__inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  gap: 0.5rem 1.5rem;
}

.site-footer p {
  margin: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 1.2rem;
}

/* ---------- Navigation ---------- */

nav.top ol,
.section-nav ol {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  padding: 0;
  margin: 0;
}

nav.top ol {
  justify-content: flex-end;
  gap: 0.4rem 1rem;
}

nav.top a {
  color: var(--vz-ink);
  font-weight: 500;
  text-decoration: none;
  padding: 0.35rem 0.7rem;
  border-radius: 999px;
  transition: background 0.2s ease, color 0.2s ease;
}

nav.top a:hover {
  background: rgba(var(--vz-accent-rgb), 0.12);
  color: var(--vz-accent);
}

nav.top a.active {
  background: var(--vz-forest);
  color: #ffffff;
}

.section-nav {
  margin-bottom: 1.75rem;
  gap: 0.65rem;
}

.section-nav ol {
  gap: 0.65rem;
}

.section-nav a {
  display: inline-block;
  padding: 0.45rem 0.9rem;
  border-radius: 999px;
  border: 1px solid var(--vz-border);
  background: rgba(18, 23, 21, 0.6);
  color: var(--vz-ink);
  font-size: 0.95rem;
  font-weight: 600;
  text-decoration: none;
  transition: border-color 0.2s ease, background 0.2s ease, color 0.2s ease;
}

.section-nav a:hover {
  border-color: var(--vz-accent-soft);
  background: rgba(var(--vz-accent-rgb), 0.08);
  color: var(--vz-accent-soft);
}

.section-nav a.active {
  border-color: var(--vz-accent);
  background: var(--vz-surface-strong);
  color: #ffffff;
}

/* ---------- Page body ---------- */

/* Page content is not a panel: it flows on the background, and cards supply the structure.
   Verso wraps each heading in a <section>, so anything given a border here would nest. */
.site-shell > article > h1 {
  margin-bottom: 0.4rem;
}

/* Intro paragraph, styled as a standfirst. */
.site-shell > article > p:first-of-type {
  max-width: 52rem;
  font-size: 1.08rem;
  color: var(--vz-muted);
}

/* Verso wraps each heading in a bare <section>; sections our own components emit always carry a
   class. Separating only the bare ones by a rule leaves the hero untouched. */
.site-shell > article > section:not([class]) {
  margin-top: 2.75rem;
  padding-top: 1.6rem;
  border-top: 1px solid var(--vz-border);
}

/* Nested sections (a card group inside a content section) need no divider of their own. */
.site-shell > article > section:not([class]) section:not([class]) {
  margin-top: 2rem;
}

.lead {
  font-size: 1.2rem;
  color: var(--vz-heading);
  max-width: 52rem;
}

.eyebrow {
  margin-bottom: 0.5rem;
  color: var(--vz-accent);
  font-size: 0.82rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.section-note {
  color: var(--vz-muted);
  font-size: 0.92rem;
  margin: -0.4rem 0 1rem;
  max-width: 62ch;
}

.clean-list {
  margin-bottom: 0;
}

.clean-list li {
  margin-bottom: 0.45rem;
}

.directive-error {
  color: #ff8a7a;
  font-weight: 600;
}

/* ---------- Hero ---------- */

.hero-panel {
  display: grid;
  grid-template-columns: minmax(0, 1.8fr) minmax(17rem, 0.9fr);
  gap: 1.6rem 2.4rem;
  align-items: center;
}

/* Grid children default to min-width:auto, which lets long words widen the column. */
.hero-panel__main {
  min-width: 0;
}

.hero-panel h1 {
  font-size: clamp(2.2rem, 4.5vw, 3.6rem);
  max-width: 24ch;
  margin-bottom: 0.35em;
}

.hero-panel .lead {
  max-width: 44rem;
  color: var(--vz-muted);
}

.hero-panel__stats {
  display: grid;
  gap: 0.8rem;
  align-content: start;
}

.hero-stat {
  display: grid;
  gap: 0.15rem;
  padding: 1rem;
  border-radius: var(--vz-radius);
  background: rgba(18, 23, 21, 0.6);
  border: 1px solid var(--vz-border);
  transition: border-color 0.2s ease, background 0.2s ease;
  text-decoration: none;
  color: inherit;
}

.hero-stat:hover {
  border-color: var(--vz-forest);
  background: rgba(60, 112, 98, 0.08);
}

.hero-stat__value {
  color: #ffffff;
  font-family: "Source Serif 4", serif;
  font-size: clamp(1.6rem, 3vw, 2.2rem);
  line-height: 1;
}

.hero-stat__label {
  color: var(--vz-muted);
  font-size: 0.9rem;
}

/* ---------- Cards ---------- */

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 1rem;
  align-items: stretch;
}

.card-grid--grants {
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
}

.track-tile,
.resource-card,
.grant-card {
  border: 1px solid var(--vz-border);
  border-radius: var(--vz-radius);
  background: var(--vz-surface);
  padding: 1.2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

/* Headings are sized by their card, so the Lean side is free to choose the level that keeps the
   document outline gap-free. */
.track-tile :is(h2, h3, h4, h5),
.resource-card :is(h2, h3, h4, h5),
.grant-card :is(h2, h3, h4, h5) {
  font-size: 1.05rem;
  margin: 0 0 0.5rem;
}

.track-tile :is(h2, h3, h4, h5) {
  font-size: 1.15rem;
}

/* A card title that is a link should not read as body-text link. */
.track-tile :is(h2, h3, h4, h5) a,
.resource-card :is(h2, h3, h4, h5) a,
.grant-card :is(h2, h3, h4, h5) a {
  color: inherit;
  text-decoration: none;
}

.track-tile :is(h2, h3, h4, h5) a:hover,
.resource-card :is(h2, h3, h4, h5) a:hover,
.grant-card :is(h2, h3, h4, h5) a:hover {
  color: var(--vz-accent-soft);
}

/* Grid-item cards fill their row height and keep a consistent internal rhythm. */
.track-tile,
.resource-card,
.grant-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1), border-color 0.3s ease,
    box-shadow 0.3s ease;
}

/* Pinned to the bottom so cards in a row line their footers up regardless of body length. */
.card-foot {
  margin-top: auto;
}

.card-foot > :last-child {
  margin-bottom: 0;
}

/* The date/venue line and the title sit together; the meta row needs no extra gap. */
.card-head .meta-row {
  margin: 0;
}

.track-tile:hover,
.resource-card:hover,
.grant-card:hover {
  transform: translateY(-4px);
  border-color: var(--vz-accent-soft);
  box-shadow: 0 16px 40px rgba(var(--vz-accent-rgb), 0.06);
}

.card-head {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
}

.metric-row,
.action-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  margin: 1rem 0;
}

.action-row {
  align-items: center;
  gap: 0.6rem 1.4rem;
}

.action-row .action-link {
  margin-top: 0;
}

.pill {
  display: inline-flex;
  align-items: center;
  padding: 0.3rem 0.7rem;
  border-radius: 999px;
  background: var(--vz-surface-strong);
  color: var(--vz-heading);
  font-size: 0.88rem;
  font-weight: 600;
}

.info-list {
  color: var(--vz-muted);
  font-size: 0.88rem;
}

.info-list strong {
  color: var(--vz-heading);
}

.info-list ul {
  display: inline;
  list-style: none;
  padding: 0;
  margin: 0;
}

.info-list li {
  display: inline;
}

.info-list li + li::before {
  content: ", ";
}

.supporting {
  color: var(--vz-muted);
}

.mini-link,
.action-link {
  display: inline-block;
  margin-top: 0.35rem;
  font-weight: 600;
  color: var(--vz-accent-soft);
  text-decoration: none;
  transition: color 0.2s ease;
}

.mini-link:hover,
.action-link:hover {
  color: var(--vz-accent);
  text-decoration: underline;
}

.action-link--primary {
  padding: 0.7rem 1rem;
  border-radius: 999px;
  background: var(--vz-forest);
  color: #ffffff;
}

.action-link--primary:hover {
  color: #ffffff;
  background: #468272;
  text-decoration: none;
}

/* ---------- Responsive ---------- */

@media (max-width: 900px) {
  .site-header__inner {
    padding: 0.75rem 0;
    flex-direction: column;
    align-items: flex-start;
  }

  nav.top ol {
    justify-content: flex-start;
  }

  .hero-panel {
    grid-template-columns: 1fr;
  }
}

@media (prefers-reduced-motion: reduce) {
  html {
    scroll-behavior: auto;
  }

  *, *::before, *::after {
    transition-duration: 0.01ms !important;
    animation-duration: 0.01ms !important;
  }

  .track-tile:hover,
  .resource-card:hover,
  .grant-card:hover {
    transform: none;
  }
}
"#

end VerifiedZkEvmSite
