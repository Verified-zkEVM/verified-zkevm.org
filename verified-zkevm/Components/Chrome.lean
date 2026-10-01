import VersoBlog
import «verified-zkevm».Routing

open Verso Genre Blog
open Template
open Verso.Output
open Verso.Output.Html

namespace VerifiedZkEvmSite

/--
Points every relative URL on the page at the site root, which is what `hrefTo` assumes.

A `<base>` only governs the elements that follow it, so this has to be emitted before the first
`href` or `src` in the document.
-/
def siteBase : Template := do
  let siteRoot := String.join ((← currentPath).toList.map fun _ => "../") ++ "./"
  return {{ <base href={{ siteRoot }}/> }}

/--
The styles and scripts belonging in `<head>`.

This is `Verso.Genre.Blog.Template.builtinHeader` minus two things: its `<base>` tag, which
`siteBase` emits earlier in the document, and its KaTeX and marked.js CDN tags, which the site
has no use for — there is no math and no client-side Markdown here, so those would be three
network requests for nothing. Everything else builtinHeader emits is reproduced, including the
per-component CSS and JS collected during rendering.
-/
def siteHeader : Template := do
  let mut out := {{ <style>{{ «verso-vars.css» }}</style> }}
  for style in (← read).builtInStyles do
    out := out ++ {{ <style>"\n"{{ .text false style }}"\n"</style> }}
  for script in (← read).builtInScripts do
    out := out ++ {{ <script>"\n"{{ .text false script }}"\n"</script> }}
  for js in (← read).jsFiles do
    out := out ++ {{ <script src=s!"-verso-data/{js}"></script> }}
  for css in (← read).cssFiles do
    out := out ++ {{ <link rel="stylesheet" href=s!"-verso-data/{css}"/> }}
  for style in (← get).headerCss do
    out := out ++ {{ <style>"\n"{{ .text false style }}"\n"</style> }}
  for script in (← get).headerJs do
    out := out ++ {{ <script>"\n"{{ .text false script }}"\n"</script> }}
  return out

/-- One navigation entry. `active` marks the section the reader is currently in. -/
def navLink (label : String) (segments : List String) (active : Bool) : Html :=
  {{
    <li>
      <a href={{ hrefTo segments }} class={{ if active then "active" else "" }}>{{ label }}</a>
    </li>
  }}

/-- Site-wide navigation. A top-level entry is active for every page beneath it. -/
def topLevelNav : Template := do
  let root := (← currentPath).toList.head?
  let entry (label : String) (segments : List String) : Html :=
    navLink label segments (segments.head? == root)
  return {{
    <nav class="top" role="navigation" aria-label="Primary">
      <ol>
        {{ entry "Home" [] }}
        {{ entry "Project" ["project"] }}
        {{ entry "Grants" ["grants"] }}
        {{ entry "Resources" ["resources"] }}
        {{ entry "Contact" ["contact"] }}
      </ol>
    </nav>
  }}

/--
Within-section navigation, shown only where a section has sibling pages.

The project section is the only one with children, so this doubles as the reader's sense of
place there and no separate breadcrumb trail is needed.
-/
def sectionNav : Template := do
  let here := (← currentPath).toList
  let entry (label : String) (segments : List String) : Html :=
    navLink label segments (here == segments)
  match here with
  | "project" :: _ =>
    return {{
      <nav class="section-nav" role="navigation" aria-label="Section">
        <ol>
          {{ entry "Overview" ["project"] }}
          {{ entry "zkVM" ["project", "zkvm"] }}
          {{ entry "EVM" ["project", "evm"] }}
          {{ entry "Cryptography" ["project", "cryptography"] }}
        </ol>
      </nav>
    }}
  | _ => return .empty

def siteFooter : Html :=
  {{
    <footer class="site-footer">
      <div class="site-footer__inner">
        <p>"An Ethereum Foundation project."</p>
        <p>
          <a href={{ hrefTo ["contact"] }}>"Contact"</a>
          <a href="https://github.com/Verified-zkEVM">"GitHub"</a>
        </p>
      </div>
    </footer>
  }}

/--
The front page renders its own heading inside the hero, so the page template must not emit the
`<h1>` that every other page gets from the title.
-/
def frontPageTemplate : Template := do
  return {{ <article>{{ ← param "content" }}</article> }}

end VerifiedZkEvmSite
