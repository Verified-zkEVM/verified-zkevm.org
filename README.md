# Verified zkEVMs in Verso

This repository is being ported from a single-page static site to a Verso site so that project information, grants, resources, and future technical documentation can grow without turning the homepage into a long scrolling document.

## Build

```bash
lake update
lake exe generate-site --output _site
```

Then serve `_site/` with any static file server.

## Structure

The current rewrite moves the site into a page hierarchy that is easier to extend:

- `/` for the landing page
- `/project/` for project overview and per-track pages
- `/grants/` for grant process and awarded grants
- `/resources/` for talks, articles, papers, and repositories
- `/contact/` for project contact details

## Notes

- Site content lives in Lean. Structured data (tracks, grants, resources) is defined in `verified-zkevm/Data.lean` and rendered through the directives in `verified-zkevm/Components/`.
- The original single-page frontend (`index.html`, `app.js`, `style.css`) and the `data/` JSON/Markdown sources have been removed; their content was ported into the Lean pages above.

## Cloudflare Pages

For Cloudflare Pages, the intended setup is to build from source rather than commit `_site/`.

- Build command: `bash build.sh`
- Build output directory: `_site`
- Recommended environment variable: `SKIP_DEPENDENCY_INSTALL=1`

`build.sh` installs `elan` if needed, loads its environment, and then runs the site generator:

```bash
bash build.sh
```

This keeps the deployment flow aligned with the local development flow and leaves `_site/` as a generated artifact.
