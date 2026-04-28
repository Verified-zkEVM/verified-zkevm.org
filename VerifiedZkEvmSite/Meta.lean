import VersoBlog

open Verso Genre Blog
open Template
open Verso.Output
open Verso.Output.Html

namespace VerifiedZkEvmSite

def siteCss : String :=
r#"
:root {
  --vz-page: #f6f1e8;
  --vz-surface: #fffdf8;
  --vz-surface-strong: #efe4d3;
  --vz-ink: #1e241f;
  --vz-muted: #59655f;
  --vz-border: #d8cbb8;
  --vz-accent: #9d4a1a;
  --vz-accent-soft: #d78f52;
  --vz-forest: #203c35;
  --vz-max: 76rem;
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
    radial-gradient(circle at top left, rgba(215, 143, 82, 0.16), transparent 28rem),
    linear-gradient(180deg, #f9f5ee 0%, var(--vz-page) 100%);
  color: var(--vz-ink);
  font-family: "IBM Plex Sans", sans-serif;
  line-height: 1.7;
}

a {
  color: var(--vz-accent);
  text-decoration-thickness: 0.08em;
  text-underline-offset: 0.16em;
}

a:hover {
  color: var(--vz-forest);
}

h1, h2, h3, h4 {
  color: var(--vz-forest);
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
  font-size: 0.95em;
}

blockquote {
  border-left: 4px solid var(--vz-accent-soft);
  margin-left: 0;
  padding: 0.2rem 0 0.2rem 1rem;
  color: var(--vz-muted);
}

.site-header {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(12px);
  background: rgba(246, 241, 232, 0.92);
  border-bottom: 1px solid rgba(216, 203, 184, 0.9);
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
  color: var(--vz-forest);
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

.frontpage {
  padding-top: 1rem;
}

.frontpage h1:first-child {
  max-width: 14ch;
  margin-bottom: 0.35em;
}

.frontpage h2 {
  padding-top: 1.4rem;
  border-top: 1px solid var(--vz-border);
}

.frontpage p:first-of-type {
  max-width: 48rem;
  font-size: 1.15rem;
  color: var(--vz-muted);
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
  color: var(--vz-forest);
  font-weight: 500;
  text-decoration: none;
}

nav.top a:hover {
  color: var(--vz-accent);
}

main article,
main section,
.post-archive,
.category-directory {
  background: rgba(255, 253, 248, 0.82);
  border: 1px solid rgba(216, 203, 184, 0.8);
  border-radius: 1.1rem;
  padding: 1.5rem;
  box-shadow: 0 18px 40px rgba(32, 60, 53, 0.05);
}

main article + article,
main article + section,
main section + article,
main section + section,
.post-archive,
.category-directory {
  margin-top: 1.25rem;
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
}
"#

instance [MonadLift m m'] [Monad m'] [MonadConfig m] : MonadConfig m' where
  currentConfig := do
    let cfg : Config ← (currentConfig : m Config)
    pure cfg

def breadcrumbs (threshold : Nat) : Template := do
  if (← read).path.size >= threshold then
    let some pathTitles ← parents (← read).site (← read).path.toList
      | pure .empty
    pure {{
      <nav class="breadcrumbs" role="navigation" aria-label="Breadcrumb">
        <ol>
          {{ crumbLinks pathTitles |>.map ({{ <li>{{ · }}</li> }}) }}
        </ol>
      </nav>
    }}
  else
    pure .empty
where
  crumbLinks (titles : List String) : List Html := go titles.length titles

  go
    | 0, xs | 1, xs => xs.map Html.ofString
    | _, [] => []
    | n + 1, x :: xs =>
      let path := String.join <| List.replicate n "../"
      {{ <a href={{ path }}>{{ x }}</a> }} :: go n xs

  parents (s : Site) (path : List String) : OptionT TemplateM (List String) :=
    match s with
    | .page _ _ contents => dirParents contents path
    | .blog _ _ contents => blogParents contents path

  dirParents (dirs : Array Dir) : (path : List String) → OptionT TemplateM (List String)
    | [] => pure []
    | p :: ps => do
      match dirs.find? (·.name == p) with
      | some (.page _ _ txt contents) => (txt.titleString :: ·) <$> dirParents contents ps
      | some (.blog _ _ txt contents) => (txt.titleString :: ·) <$> blogParents contents ps
      | some (.static ..) | none => failure

  blogParents (posts : Array BlogPost) : (path : List String) → OptionT TemplateM (List String)
    | [] => pure []
    | [p] => do
      match ← posts.findM? (fun x => x.postName' <&> (· == p)) with
      | some post => pure [post.contents.titleString]
      | none => failure
    | _ => failure

end VerifiedZkEvmSite
