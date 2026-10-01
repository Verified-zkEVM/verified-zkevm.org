import VersoBlog
import «verified-zkevm».Components.Cards

open Verso Genre Blog
open Verso.Output
open Verso.Output.Html
open Verso.Doc.Html

namespace VerifiedZkEvmSite

/-!
Directives usable from page sources. Each one renders structured data from `Data.lean`; none of
them take content, so the block bodies in the `.lean` pages are empty by design.

Heading levels are fixed per directive to match where the directive is used, so that every page
has a gap-free outline. If a directive moves to a different depth, its level moves with it.
-/

/-- Rendered in place of a directive whose argument does not name anything. -/
private def unknown (what : String) : Html :=
  {{ <p class="directive-error">"Unknown " {{ what }} "."</p> }}

/-- Resolves a track slug, rendering an error in place of the directive if it does not name one. -/
private def withTrack (slug : String) (render : TrackKey → Html) : Html :=
  match trackKeyOfSlug? slug with
  | some key => render key
  | none => unknown s!"track “{slug}”"

block_component +directive home_hero where
  toHtml _ _ _ _ _ := pure {{
    <section class="hero-panel" id="top">
      <div class="hero-panel__main">
        <p class="eyebrow">"Ethereum Foundation initiative"</p>
        <h1>"Formal verification for zkEVMs"</h1>
        <p class="lead">"We support formal verification of zkVMs, EVM implementations, and cryptographic proof systems to strengthen assurance across the zkEVM stack. Explore the research, tools, and teams supported by the project."</p>
        <div class="action-row">
          <a href={{ hrefTo ["project"] }} class="action-link action-link--primary">"Explore the project"</a>
          <a href={{ hrefTo ["grants"] }} class="action-link">"See funded work"</a>
          <a href={{ hrefTo ["resources"] }} class="action-link">"Browse resources"</a>
        </div>
      </div>
      <div class="hero-panel__stats">
        <a class="hero-stat" href={{ hrefTo ["project"] }}>
          <span class="hero-stat__value">{{ toString tracks.size }}</span>
          <span class="hero-stat__label">"tracks"</span>
        </a>
        <a class="hero-stat" href={{ hrefTo ["grants"] }}>
          <span class="hero-stat__value">{{ toString grants.size }}</span>
          <span class="hero-stat__label">"grants awarded"</span>
        </a>
        <a class="hero-stat" href={{ hrefTo ["resources"] }}>
          <span class="hero-stat__value">{{ toString resources.size }}</span>
          <span class="hero-stat__label">"resources"</span>
        </a>
      </div>
    </section>
  }}

/-- Tile per track. Used under a level-2 heading on the project overview. -/
block_component +directive featured_tracks where
  toHtml _ _ _ _ _ := pure {{
    <div class="card-grid">
      {{ tracks.map (renderTrackTile 3) }}
    </div>
  }}

/-- Opens a track page, directly under its `<h1>`. -/
block_component +directive track_header (track : String) where
  toHtml _ _ _ _ _ :=
    pure <| withTrack track renderTrackHeader

/-- Used under the level-2 "Overview" heading of a track page. -/
block_component +directive track_overview (track : String) where
  toHtml _ _ _ _ _ :=
    pure <| withTrack track renderTrackOverview

/-- Used under the level-2 "Verification Goals" heading of a track page. -/
block_component +directive track_goals (track : String) where
  toHtml _ _ _ _ _ :=
    pure <| withTrack track renderTrackGoals

/-- Everything tagged for one track, under the level-2 heading of a track page. -/
block_component +directive resources_for (track : String) where
  toHtml _ _ _ _ _ := pure <| withTrack track fun key =>
    let grantSection :=
      match grantsForTrack key with
      | #[] => Html.empty
      | items => renderGrantSection 3 "Grants" items
    let kindSections := #[ResourceKind.repo, .talk, .paper, .article].filterMap fun kind =>
      match (resourcesForTrack key).filter (·.kind == kind) with
      | #[] => none
      | items => some <| renderResourceSection 3 kind.title none items
    {{ <div>{{ grantSection }}{{ Html.seq kindSections }}</div> }}

/-- Every awarded grant, grouped, under the level-2 "Awarded Grants" heading. -/
block_component +directive awarded_grants where
  toHtml _ _ _ _ _ :=
    let sections := grantSectionOrder.toArray.filterMap fun title =>
      match grants.filter (·.group == title) with
      | #[] => none
      | items => some <| renderGrantSection 3 title items
    pure {{ <div>{{ Html.seq sections }}</div> }}

/--
One kind of resource as a level-2 section of the resources page. `papers` carries a standing
caveat about co-funding.
-/
block_component +directive resource_section (kind : String) where
  toHtml _ _ _ _ _ :=
    pure <|
      match resourceKindOfString? kind with
      | none => unknown s!"resource kind “{kind}”"
      | some resourceKind =>
        let note :=
          if resourceKind == .paper then
            some "Papers may be co-funded with other organizations, and not all authors are necessarily funded by this project."
          else none
        renderResourceSection 2 resourceKind.title note (resourceItemsByKind resourceKind)

end VerifiedZkEvmSite
