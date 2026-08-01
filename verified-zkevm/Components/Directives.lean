import VersoBlog
import «verified-zkevm».Components.Cards

open Verso Genre Blog
open Verso.Output
open Verso.Output.Html
open Verso.Doc.Html

namespace VerifiedZkEvmSite

block_component +directive featured_tracks where
  toHtml _ _ _ _ _ := do
    let trackTiles ← tracks.mapM fun track => do
      let href ← htmlHrefTo track.key.path
      pure <| renderTrackTile track href
    pure {{
      <div class="card-grid card-grid--tracks">
        {{ Html.seq trackTiles }}
      </div>
    }}

block_component +directive featured_resources where
  toHtml _ _ _ _ _ := pure {{
    <div class="card-grid">
      {{ featuredResources.map renderResourceCard }}
    </div>
  }}

block_component +directive home_hero where
  toHtml _ _ _ _ _ := do
    let trackCount := tracks.size
    let grantCount := grants.size
    let resourceCount := resources.size
    let projectHref ← htmlHrefTo ["project"]
    let grantsHref ← htmlHrefTo ["grants"]
    let resourcesHref ← htmlHrefTo ["resources"]
    pure {{
      <section class="hero-panel">
        <div class="hero-panel__main">
          <p class="eyebrow">"Ethereum Foundation initiative"</p>
          <h1>"Formal verification for zkEVMs, with one place for project context, funded work, and technical outputs."</h1>
          <p class="lead">"The site is organized around three tracks, an awarded-grants record, and a shared resource library so it can stay readable as documentation grows."</p>
          <div class="action-row">
            <a href={{ projectHref }} class="action-link action-link--primary">"Explore the project"</a>
            <a href={{ grantsHref }} class="action-link">"See funded work"</a>
            <a href={{ resourcesHref }} class="action-link">"Browse resources"</a>
          </div>
        </div>
        <div class="hero-panel__stats">
          <a class="hero-stat" href={{ projectHref }}>
            <span class="hero-stat__value">{{ toString trackCount }}</span>
            <span class="hero-stat__label">"tracks"</span>
          </a>
          <a class="hero-stat" href={{ grantsHref }}>
            <span class="hero-stat__value">{{ toString grantCount }}</span>
            <span class="hero-stat__label">"grants awarded"</span>
          </a>
          <a class="hero-stat" href={{ resourcesHref }}>
            <span class="hero-stat__value">{{ toString resourceCount }}</span>
            <span class="hero-stat__label">"resources"</span>
          </a>
        </div>
      </section>
    }}

block_component +directive track_spotlight (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    pure <| renderTrackSpotlight key

block_component +directive track_overview (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    pure <| renderTrackOverview key

block_component +directive resources_for (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    -- Grants tagged for this track.
    let trackGrants := grantsForTrack key
    let grantSection :=
      if trackGrants.isEmpty then
        Html.empty
      else {{
        <section>
          <h3>"Grants"</h3>
          <div class="card-grid card-grid--grants">
            {{ Html.seq (trackGrants.map renderGrantCard) }}
          </div>
        </section>
      }}
    -- All other resources tagged for this track, grouped by kind.
    let kindSections : Array Html := #[.repo, .talk, .paper, .article].filterMap fun kind =>
      let items := (resourcesForTrack key).filter (·.kind == kind)
      if items.isEmpty then none
      else some {{
        <section>
          <h3>{{ kind.title }}</h3>
          <div class="card-grid">
            {{ items.map renderResourceCard }}
          </div>
        </section>
      }}
    pure {{
      <div>
        {{ grantSection }}
        {{ Html.seq kindSections }}
      </div>
    }}

block_component +directive awarded_grants where
  toHtml _ _ _ _ _ := do
    let sections := grantSectionOrder.toArray.filterMap fun title =>
      let items := grants.filter (·.group == title)
      if items.isEmpty then none
      else some <| renderGrantSection title items
    pure {{
      <div>
        {{ Html.seq sections }}
      </div>
    }}

block_component +directive resource_section (kind : String) where
  toHtml _ _ _ _ _ := do
    let some resourceKind := resourceKindOfString? kind
      | pure {{ <p>"Unknown resource kind."</p> }}
    pure <| renderResourceSectionHtml resourceKind.title (resourceItemsByKind resourceKind)

block_component +directive repo_grid where
  toHtml _ _ _ _ _ := pure <| renderResourceSectionHtml "Repositories" (resourceItemsByKind .repo)

block_component +directive papers_section where
  toHtml _ _ _ _ _ := pure <| renderResourceSectionWithNote "Papers"
    "Papers may be co-funded with other organizations, and not all authors are necessarily funded by this project."
    (resourceItemsByKind .paper)

end VerifiedZkEvmSite
