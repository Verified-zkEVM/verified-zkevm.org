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
- `/project/` for project overview and track structure
- `/grants/` for grant process and awarded grants
- `/resources/` for talks, articles, papers, and repositories
- `/activity/` for tracked ecosystem activity
- `/docs/` reserved for future technical documentation
- `/updates/` reserved for future time-based updates

## Notes

- The original static frontend files are still present during the migration.
- The `data/` directory remains a useful source of truth while the content is being ported into Lean pages.
- The current activity feed has not been reimplemented as a live client-side widget; the Verso version is structured so this can be added later as a build-time or curated page instead.

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
