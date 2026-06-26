import VersoBlog
import «verified-zkevm».Routing

open Verso Genre Blog Site Syntax
open Template
open Verso.Output
open Verso.Output.Html

namespace VerifiedZkEvmSite

def navLink (label : String) (segments : List String) (active : Bool) : TemplateM Html := do
  let href ← hrefTo segments
  pure {{
    <li>
      <a href={{ href }} class={{ if active then "active" else "" }}>{{ label }}</a>
    </li>
  }}

def topLevelNav : Template := do
  let homeActive ← pathActive []
  let projectActive ← rootActive "project"
  let grantsActive ← rootActive "grants"
  let resourcesActive ← rootActive "resources"
  let contactActive ← rootActive "contact"
  pure {{
    <nav class="top" role="navigation" aria-label="Primary">
      <ol>
        {{ ← navLink "Home" [] homeActive }}
        {{ ← navLink "Project" ["project"] projectActive }}
        {{ ← navLink "Grants" ["grants"] grantsActive }}
        {{ ← navLink "Resources" ["resources"] resourcesActive }}
        {{ ← navLink "Contact" ["contact"] contactActive }}
      </ol>
    </nav>
  }}

def sectionNav : Template := do
  let here := (← currentPath).toList
  let mkEntry (label : String) (segments : List String) := do
    let href ← hrefTo segments
    let active := here == segments
    pure {{
      <li>
        <a href={{ href }} class={{ if active then "active" else "" }}>{{ label }}</a>
      </li>
    }}
  let entries ←
    match here with
    | "project" :: _ =>
      pure <| some #[
        ← mkEntry "Overview" ["project"],
        ← mkEntry "zkVM" ["project", "zkvm"],
        ← mkEntry "EVM" ["project", "evm"],
        ← mkEntry "Cryptography" ["project", "cryptography"]
      ]
    | _ => pure none
  match entries with
  | none => pure .empty
  | some links => pure {{
      <nav class="section-nav" role="navigation" aria-label="Section">
        <ol>{{ links }}</ol>
      </nav>
    }}


instance [MonadLift m m'] [Monad m'] [MonadConfig m] : MonadConfig m' where
  currentConfig := do
    let cfg : Config ← (currentConfig : m Config)
    pure cfg

def breadcrumbs (threshold : Nat) : Template := do
  let pathSegments := (← read).path.toList
  if pathSegments.length >= threshold then
    let some pathTitles ← parents (← read).site pathSegments
      | pure .empty
    pure {{
      <nav class="breadcrumbs" role="navigation" aria-label="Breadcrumb">
        <ol>
          {{ crumbLinks pathSegments pathTitles |>.map ({{ <li>{{ · }}</li> }}) }}
        </ol>
      </nav>
    }}
  else
    pure .empty
where
  crumbLinks (segs : List String) (titles : List String) : List Html :=
    {{ <a href="./">"Home"</a> }} :: go [] segs titles

  go (accum : List String) : List String → List String → List Html
    | [], _ => []
    | _, [] => []
    | [_], [title] => [Html.ofString title]
    | seg :: segs, title :: titles =>
      let nextAccum := accum ++ [seg]
      let href := String.join (nextAccum.map (· ++ "/"))
      {{ <a href={{ href }}>{{ title }}</a> }} :: go nextAccum segs titles

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
