namespace VerifiedZkEvmSite

def siteCss : String :=
r#"
:root {
  --vz-page: #0a0d0b;
  --vz-surface: #121715;
  --vz-surface-strong: #1a221f;
  --vz-ink: #e2e8e5;
  --vz-muted: #83958c;
  --vz-border: #222d28;
  --vz-accent: #0f9f90;
  --vz-accent-soft: #3fcabc;
  --vz-accent-rgb: 15, 159, 144;
  --vz-forest: #3c7062;
  --vz-max: 76rem;

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
}

a {
  color: var(--vz-accent-soft);
  text-decoration-thickness: 0.08em;
  text-underline-offset: 0.16em;
  transition: all 0.2s ease;
}

a:hover {
  color: #52a692;
}

h1, h2, h3, h4 {
  color: #c4ded2;
  font-family: "Source Serif 4", serif;
  line-height: 1.15;
  margin: 0 0 0.6em;
}

h1 {
  font-size: clamp(2.4rem, 5vw, 4.2rem);
}

h2 {
  font-size: clamp(1.7rem, 2.5vw, 2.4rem);
  margin-top: 2.8rem;
}

h3 {
  font-size: 1.35rem;
  margin-top: 2rem;
}

p, ul, ol, blockquote, pre {
  margin: 0 0 1rem;
}

ul, ol {
  padding-left: 1.35rem;
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

.site-header {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(12px);
  background: rgba(10, 13, 11, 0.9);
  border-bottom: 1px solid var(--vz-border);
}

.site-header__inner {
  width: min(var(--vz-max), calc(100vw - 2rem));
  margin: 0 auto;
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
  color: #c4ded2;
  font-weight: 700;
  text-decoration: none;
  letter-spacing: 0.01em;
}

.site-mark img {
  width: 2rem;
  height: 2rem;
}

.site-main {
  padding: 2rem 0 4rem;
}

.site-shell {
  width: min(var(--vz-max), calc(100vw - 2rem));
  margin: 0 auto;
}

.site-shell > .section-nav {
  margin-bottom: 1.25rem;
}

.lead {
  font-size: 1.2rem;
  color: #c4ded2;
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

.frontpage {
  padding-top: 0.25rem;
}

.frontpage h1:first-child {
  max-width: 14ch;
  margin-bottom: 0.35em;
}

.frontpage h2 {
  padding-top: 1.4rem;
  border-top: 1px solid var(--vz-border);
}

.breadcrumbs {
  margin-bottom: 1.25rem;
  font-size: 0.95rem;
  color: var(--vz-muted);
}

.breadcrumbs ol {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  gap: 0.45rem;
  padding: 0;
  margin: 0;
}

.breadcrumbs li::after {
  content: "/";
  margin-left: 0.45rem;
  color: var(--vz-border);
}

.breadcrumbs li:last-child::after {
  content: "";
  margin: 0;
}

nav.top ol {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 0.4rem 1rem;
  padding: 0;
  margin: 0;
}

nav.top a {
  color: var(--vz-ink);
  font-weight: 500;
  text-decoration: none;
  padding: 0.35rem 0.7rem;
  border-radius: 999px;
  transition: all 0.2s ease;
}

nav.top a:hover {
  background: rgba(var(--vz-accent-rgb), 0.12);
  color: var(--vz-accent);
}

nav.top a.active {
  background: var(--vz-forest);
  color: #ffffff;
}

.section-nav ol {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  gap: 0.65rem;
  padding: 0;
  margin: 0;
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
  transition: all 0.2s ease;
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

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 1rem;
  align-items: stretch;
}

.card-grid--tracks {
  margin-top: 1rem;
}

.card-grid--grants {
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
}

.track-tile,
.resource-card,
.grant-card,
.spotlight-card {
  border: 1px solid var(--vz-border);
  border-radius: 1rem;
  background: rgba(18, 23, 21, 0.7);
  padding: 1.2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

/* Grid-item cards fill their row height and keep a consistent internal rhythm */
.track-tile,
.resource-card,
.grant-card {
  display: flex;
  flex-direction: column;
  height: 100%;
}

/* Pin the awarded-to line and any footer links to the bottom so cards align */
.grant-card .supporting {
  margin-top: auto;
}

/* Pin the track-tile footer (metric pills + Explore link) to the bottom so
   tiles with different description lengths still align across a row */
.track-tile .metric-row {
  margin-top: auto;
}

.track-tile:hover,
.resource-card:hover,
.grant-card:hover {
  transform: translateY(-4px);
  border-color: var(--vz-accent-soft);
  box-shadow: 0 16px 40px rgba(var(--vz-accent-rgb), 0.06);
}

.track-tile h3,
.resource-card h3,
.grant-card h3,
.spotlight-card h3 {
  margin-top: 0;
}

.track-tile h3 {
  font-size: 1.15rem;
}

.resource-card h3,
.grant-card h3 {
  font-size: 1.05rem;
}

.spotlight-card--warm {
  background:
    linear-gradient(135deg, rgba(var(--vz-accent-rgb), 0.12), rgba(60, 112, 98, 0.08)),
    rgba(18, 23, 21, 0.85);
  border-color: rgba(var(--vz-accent-rgb), 0.25);
}

.metric-row,
.action-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  margin: 1rem 0;
}

.pill {
  display: inline-flex;
  align-items: center;
  padding: 0.3rem 0.7rem;
  border-radius: 999px;
  background: var(--vz-surface-strong);
  color: #c4ded2;
  font-size: 0.88rem;
  font-weight: 600;
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
  transition: all 0.2s ease;
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
  text-decoration: none;
}

.action-link--primary:hover {
  color: #ffffff;
  background: #468272;
}

.hero-panel {
  display: grid;
  grid-template-columns: minmax(0, 1.8fr) minmax(17rem, 0.9fr);
  gap: 1.2rem;
  margin-bottom: 1.6rem;
  padding: 1.6rem;
  border: 1px solid rgba(var(--vz-accent-rgb), 0.15);
  border-radius: 1.5rem;
  background:
    radial-gradient(circle at top right, rgba(var(--vz-accent-rgb), 0.15), transparent 20rem),
    linear-gradient(135deg, rgba(60, 112, 98, 0.1), rgba(18, 23, 21, 0.8)),
    #0c0f0d;
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.4);
}

.hero-panel h1 {
  max-width: 11ch;
  margin-bottom: 0.35em;
  color: #ffffff;
}

.hero-panel .lead {
  max-width: 44rem;
  color: var(--vz-muted);
}

.hero-panel__stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.8rem;
  align-content: start;
}

.hero-stat {
  display: grid;
  gap: 0.15rem;
  padding: 1rem;
  border-radius: 1rem;
  background: rgba(18, 23, 21, 0.6);
  border: 1px solid var(--vz-border);
  transition: all 0.2s ease;
  text-decoration: none;
  color: inherit;
  cursor: pointer;
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

.detail-stack {
  display: grid;
  gap: 1.1rem;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1rem;
  align-items: stretch;
}

.detail-card {
  border: 1px solid var(--vz-border);
  border-radius: 1rem;
  background: rgba(18, 23, 21, 0.7);
  padding: 1.2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  height: 100%;
}

/* Small caption attached to a section, e.g. the papers disclaimer */
.section-note {
  color: var(--vz-muted);
  font-size: 0.92rem;
  margin: -0.2rem 0 0.7rem;
  max-width: 62ch;
}

.landing-page {
  background: transparent;
}

.landing-page > h1:first-child {
  margin-bottom: 0.2rem;
  color: #ffffff;
}

.landing-page > p:first-of-type {
  max-width: 48rem;
  font-size: 1.08rem;
  color: var(--vz-muted);
}

.landing-page > p:nth-of-type(2) {
  max-width: 52rem;
}

.spotlight-card--status {
  background:
    linear-gradient(135deg, rgba(60, 112, 98, 0.08), rgba(var(--vz-accent-rgb), 0.06)),
    rgba(18, 23, 21, 0.85);
}

.spotlight-card--outcomes {
  background:
    linear-gradient(135deg, rgba(var(--vz-accent-rgb), 0.08), rgba(60, 112, 98, 0.04)),
    rgba(18, 23, 21, 0.85);
}

.clean-list {
  margin-bottom: 0;
}

.clean-list li {
  margin-bottom: 0.45rem;
}

.card-head {
  display: flex;
  flex-direction: column;
  gap: 0.45rem;
}

main article,
main section,
.post-archive,
.category-directory {
  background: rgba(18, 23, 21, 0.5);
  border: 1px solid var(--vz-border);
  border-radius: 1.1rem;
  padding: 1.5rem;
  box-shadow: 0 18px 40px rgba(0, 0, 0, 0.2);
}

main article + article,
main article + section,
main section + article,
main section + section,
.post-archive,
.category-directory {
  margin-top: 1.25rem;
}

/* The stacked-content spacing above must not leak into cards, which are
   adjacent <article>/<section> siblings inside their grids. */
.card-grid > article,
.card-grid > section,
.detail-grid > article,
.detail-grid > section {
  margin-top: 0;
}

main article > h1 {
  font-size: clamp(2rem, 4vw, 3rem);
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
"#


end VerifiedZkEvmSite
