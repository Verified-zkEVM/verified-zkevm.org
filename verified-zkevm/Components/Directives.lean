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

block_component +directive grant_snapshot where
  toHtml _ _ _ _ _ := do
    let total := grants.size
    let openHref ← htmlHrefTo ["grants"]
    pure {{
      <section class="spotlight-card spotlight-card--warm">
        <p class="eyebrow">"Grants"</p>
        <p class="lead">"Applications are currently closed. The grants page covers the funding process, current calls, and the full record of awarded work."</p>
        <div class="metric-row">
          <span class="pill">{{ s!"{total} recorded awards" }}</span>
          <span class="pill">"application guidelines available"</span>
        </div>
        <div class="action-row">
          <a href={{ openHref }} class="action-link">"Grants: apply and awarded work"</a>
        </div>
      </section>
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
    let resourceCount := resources.filter (·.kind != .repo) |>.size
    let repoCount := resources.filter (·.kind == .repo) |>.size
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
            <span class="hero-stat__label">"recorded awards"</span>
          </a>
          <a class="hero-stat" href={{ resourcesHref }}>
            <span class="hero-stat__value">{{ toString resourceCount }}</span>
            <span class="hero-stat__label">"talks, papers, and articles"</span>
          </a>
          <a class="hero-stat" href={{ resourcesHref }}>
            <span class="hero-stat__value">{{ toString repoCount }}</span>
            <span class="hero-stat__label">"tracked repositories"</span>
          </a>
        </div>
      </section>
    }}

block_component +directive track_spotlight (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    pure <| renderTrackSpotlight key

block_component +directive track_status (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    pure <| renderTrackStatus key

block_component +directive track_outcomes (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    renderTrackOutcomes key

block_component +directive grants_for (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    let items := (grantsForTrack key).take 6
    let cards ← items.mapM fun grant => do
      let outcomeHref ←
        match grantCaseStudyForAward? grant with
        | some detail => do
          let href ← htmlHrefTo ["grants", detail.slug]
          pure <| some href
        | none => pure none
      pure <| renderGrantCard grant outcomeHref
    let href ← htmlHrefTo ["grants"]
    pure {{
      <div>
        <div class="card-grid card-grid--grants">
          {{ Html.seq cards }}
        </div>
        <p><a href={{ href }} class="mini-link">"View all awarded grants"</a></p>
      </div>
    }}

block_component +directive resources_for (track : String) where
  toHtml _ _ _ _ _ := do
    let some key := trackKeyOfSlug? track
      | pure {{ <p>"Unknown track."</p> }}
    let items := (resourcesForTrack key).filter (·.kind != .repo) |>.take 6
    let repoItems := (resourcesForTrack key).filter (·.kind == .repo) |>.take 3
    pure {{
      <div>
        <div class="card-grid">
          {{ items.map renderResourceCard }}
        </div>
        {{ if repoItems.isEmpty then .empty else {{
          <section>
            <h3>"Related repositories"</h3>
            <div class="card-grid">
              {{ repoItems.map renderResourceCard }}
            </div>
          </section>
        }} }}
      </div>
    }}

block_component +directive awarded_grants where
  toHtml _ _ _ _ _ := do
    let sections ← grantSectionOrder.toArray.mapM fun title => do
      let items := grants.filter (·.group == title)
      if items.isEmpty then
        pure none
      else
        let itemsWithHrefs ← items.mapM fun grant => do
          let outcomeHref ←
            match grantCaseStudyForAward? grant with
            | some detail => do
              let href ← htmlHrefTo ["grants", detail.slug]
              pure <| some href
            | none => pure none
          pure (grant, outcomeHref)
        pure <| some <| renderGrantSection title itemsWithHrefs
    pure {{
      <div>
        {{ Html.seq (sections.filterMap id) }}
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

block_component +directive grant_case_study (slug : String) where
  toHtml _ _ _ _ _ := do
    pure <| renderGrantCaseStudy slug


end VerifiedZkEvmSite
