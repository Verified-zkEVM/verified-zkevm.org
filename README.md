# Verified zkEVMs in Verso

The Verified zkEVMs website is built with Verso and Lean. Project information, awarded grants, and resources are organized into separate pages.

## Build

```bash
bash build.sh
```

The build uses the Lean version in `lean-toolchain` and the dependencies pinned in `lake-manifest.json`. Then serve `_site/` with any static file server, for example:

```bash
python3 -m http.server 8000 --bind 127.0.0.1 --directory _site
```

## Structure

The site has the following pages:

- `/` for the landing page
- `/project/` for project overview and per-track pages
- `/grants/` for grant process and awarded grants
- `/resources/` for talks, articles, papers, and repositories
- `/contact/` for project contact details

## Source layout

| Path | Contents |
| --- | --- |
| `verified-zkevm/Data.lean` | Tracks, grants, and resources — the single source of truth for everything the site lists |
| `verified-zkevm/Components/Cards.lean` | Pure `Html`-valued renderers for cards and card sections |
| `verified-zkevm/Components/Directives.lean` | The `:::name` directives the page sources call |
| `verified-zkevm/Components/Chrome.lean` | `<head>`, navigation, and footer |
| `verified-zkevm/Theme/Css.lean` | The whole stylesheet |
| `Main.lean` | Theme, page template overrides, and the site tree |

Track overview text and verification goals are intentionally blank for manual editing. Fill in each track's `focus`, `overview`, and `verificationGoals` fields in `Data.lean` to populate these sections.

## Conventions

Two rules keep the presentation from drifting as content is added:

- **Cards are the only panels.** A bordered, padded surface belongs to a card class
  (`.track-tile`, `.resource-card`, `.grant-card`) and never to the
  `<article>`/`<section>` elements Verso generates around page content. Those nest, so styling
  them stacks concentric boxes. Top-level content sections are separated by a rule instead.
- **Heading levels are passed in, not hardcoded.** Card and section renderers take a `level`
  argument so the same card can sit at different depths on different pages without leaving a gap
  in the document outline. The stylesheet sizes headings by the enclosing card class, so the
  level carries semantics only and never changes how anything looks.

Other notes:

- The original single-page frontend (`index.html`, `app.js`, `style.css`) and the `data/`
  JSON/Markdown sources have been removed; their content was ported into the Lean pages above.
- `static_files/legacy-links.js` redirects the original homepage section bookmarks (such as
  `/#grants` and `/#documentation`) to their new pages.
- `Components/Chrome.lean` reimplements Verso's `builtinHeader` so it can leave out the KaTeX and
  marked.js CDN tags, which this site has no use for. If Verso's version gains something new, that
  function is where to mirror it.

## Cloudflare Pages

Cloudflare Pages builds from source; `_site/` is generated and is not committed.

- Build command: `bash build.sh`
- Build output directory: `_site`
- Root directory: the repository root
- Production branch: `main`
- Recommended environment variable: `SKIP_DEPENDENCY_INSTALL=1`

The previous single-page site served the repository root without a build. Update the Pages build command and output directory for this migration, and verify a preview deployment before merging to `main`.

`build.sh` installs `elan` if needed, loads its environment, and then runs the site generator:

```bash
bash build.sh
```

This keeps the deployment flow aligned with the local development flow and leaves `_site/` as a generated artifact.
