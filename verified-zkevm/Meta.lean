import VersoBlog
import «verified-zkevm».Data

open Verso Genre Blog
open Template
open Verso.Output
open Verso.Output.Html
open Verso.Doc.Html

namespace VerifiedZkEvmSite

def hrefTo (segments : List String) : TemplateM String := do
  let dest ← relative segments
  if dest.isEmpty then
    pure "./"
  else
    pure <| String.join (dest.map (· ++ "/"))

def currentRoot? : TemplateM (Option String) := do
  pure <| (← currentPath).toList.head?

def pathActive (segments : List String) : TemplateM Bool := do
  pure <| (← currentPath).toList == segments

def rootActive (root : String) : TemplateM Bool := do
  pure <| (← currentRoot?) == some root

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
  let docsActive ← rootActive "docs"
  let updatesActive ← rootActive "updates"
  let contactActive ← rootActive "contact"
  pure {{
    <nav class="top" role="navigation" aria-label="Primary">
      <ol>
        {{ ← navLink "Home" [] homeActive }}
        {{ ← navLink "Project" ["project"] projectActive }}
        {{ ← navLink "Grants" ["grants"] grantsActive }}
        {{ ← navLink "Resources" ["resources"] resourcesActive }}
        {{ ← navLink "Docs" ["docs"] docsActive }}
        {{ ← navLink "Updates" ["updates"] updatesActive }}
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
        -- Use relative path to project overview
        ← mkEntry "Overview" ["project"],
        ← mkEntry "Tracks" ["project", "tracks"]
      ]
    | "grants" :: _ =>
      pure <| some #[
        ← mkEntry "Overview" ["grants"],
        ← mkEntry "RFPs" ["grants", "rfps"],
        ← mkEntry "Apply" ["grants", "application-guidelines"],
        ← mkEntry "Awarded" ["grants", "awarded"]
      ]
    | "resources" :: _ =>
      pure <| some #[
        ← mkEntry "Overview" ["resources"],
        ← mkEntry "Repositories" ["resources", "repositories"],
        -- Use correct url for Talks page
        ← mkEntry "Talks" ["resources", "talks-and-videos"],
        ← mkEntry "Articles" ["resources", "articles"],
        ← mkEntry "Papers" ["resources", "papers"]
      ]
    | _ => pure none
  match entries with
  | none => pure .empty
  | some links => pure {{
      <nav class="section-nav" role="navigation" aria-label="Section">
        <ol>{{ links }}</ol>
      </nav>
    }}

def metaLine (date source : String) : String :=
  match date.isEmpty, source.isEmpty with
  | true, true => ""
  | false, true => date
  | true, false => source
  | false, false => s!"{date} · {source}"

def absoluteHref (segments : List String) : String :=
  match segments with
  | [] => "/"
  | _ => "/" ++ String.intercalate "/" segments ++ "/"

def renderInfoListCompact (title : String) (items : List String) : Html :=
  if items.isEmpty then
    .empty
  else
    let listItems : Array Html := items.toArray.map fun item =>
      Html.tag "li" #[] (Html.ofString item)
    {{
      <span class="info-list">
        <strong>{{ title }}": "</strong>
        <ul>{{ Html.seq listItems }}</ul>
      </span>
    }}

def htmlHrefTo (target : List String) : HtmlM Page String := do
  let ctx ← HtmlT.context
  let current := ctx.path.toList
  let dest := relativize current target
  if dest.isEmpty then
    pure "./"
  else
    pure <| String.join (dest.map (· ++ "/"))
where
  relativize (me target : List String) : List String :=
    match me, target with
    | [], any => any
    | any, [] => any.map (fun _ => "..")
    | x :: xs, y :: ys =>
      if x == y then
        relativize xs ys
      else
        (x :: xs).map (fun _ => "..") ++ (y :: ys)

def renderGrantLink (grant : GrantAward) : Html :=
  match grant.url, grant.urlLabel with
  | some url, some label => {{ <a href={{ url }} class="mini-link">{{ label }}</a> }}
  | some url, none => {{ <a href={{ url }} class="mini-link">"Link"</a> }}
  | none, _ => .empty

def renderGrantCard (grant : GrantAward) (outcomeHref : Option String) : Html :=
  let periodHtml :=
    match grant.period with
    | some period => {{ <span class="pill">{{ period }}</span> }}
    | none => .empty
  let detailLink :=
    match outcomeHref with
    | some href =>
      {{ <a href={{ href }} class="mini-link">"Outcome page"</a> }}
    | none => .empty
  {{
    <article class="grant-card">
      <div class="card-head">
        <h3>{{ grant.title }}</h3>
        <div class="meta-row">
          {{ periodHtml }}
        </div>
      </div>
      <p>{{ grant.description }}</p>
      <p class="supporting">
        <strong>"Awarded to: "</strong>{{ grant.awardedTo }}
      </p>
      {{ renderGrantLink grant }}
      {{ detailLink }}
    </article>
  }}

def renderResourceCard (item : ResourceItem) : Html :=
  let metaText := metaLine item.dateLabel item.sourceLabel
  let metaHtml :=
    if metaText.isEmpty then
      .empty
    else
      {{ <p class="supporting">{{ metaText }}</p> }}
  let blurb :=
    match item.blurb? with
    | some blurbText => {{ <p class="supporting">{{ blurbText }}</p> }}
    | none => .empty
  let linkItems :=
    match item.kind with
    | .article =>
      {{
        <div class="metric-row">
          <span class="pill">"Article"</span>
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Read article"</a>
      }}
    | .paper =>
      {{
        <div class="metric-row">
          <span class="pill">"Paper"</span>
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Read paper"</a>
      }}
    | .talk =>
      {{
        <div class="metric-row">
          <span class="pill">"Talk / Video"</span>
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Watch video"</a>
      }}
    | .repo =>
      let codeLink := {{ <a href={{ item.url }} class="mini-link">"GitHub repository"</a> }}
      {{
        <div class="metric-row">
          <span class="pill">"Repository"</span>
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        {{ codeLink }}
      }}
  {{
    <article class="resource-card">
      {{ metaHtml }}
      <h3>{{ item.title }}</h3>
      {{ blurb }}
      {{ linkItems }}
    </article>
  }}

def renderTrackTile (track : TrackInfo) (href : String) : Html :=
  let grantCount := (grantsForTrack track.key).size
  let resourceCount := (resourcesForTrack track.key).filter (·.kind != .repo) |>.size
  let repoCount := (resourcesForTrack track.key).filter (·.kind == .repo) |>.size
  {{
    <article class="track-tile">
      <p class="eyebrow">{{ track.key.title }}</p>
      <h3><a href={{ href }}>{{ track.summary }}</a></h3>
      <p>{{ track.focus }}</p>
      <div class="metric-row">
        <span class="pill">{{ s!"{grantCount} grants" }}</span>
        <span class="pill">{{ s!"{resourceCount} resources" }}</span>
        <span class="pill">{{ s!"{repoCount} repos" }}</span>
      </div>
      <a href={{ href }} class="mini-link">"Explore track"</a>
    </article>
  }}

def renderTrackSpotlight (key : TrackKey) : Html :=
  let track := trackInfo! key
  let grantCount := (grantsForTrack key).size
  let resourceCount := (resourcesForTrack key).filter (·.kind != .repo) |>.size
  let repoCount := (resourcesForTrack key).filter (·.kind == .repo) |>.size
  let nextItems : Array Html := track.whatNext.toArray.map fun item =>
    Html.tag "li" #[] (Html.ofString item)
  {{
    <section class="spotlight-card">
      <p class="eyebrow">{{ track.key.title }} " spotlight"</p>
      <p class="lead">{{ track.summary }}</p>
      <p>{{ track.focus }}</p>
      <div class="metric-row">
        <span class="pill">{{ s!"{grantCount} awarded grants" }}</span>
        <span class="pill">{{ s!"{resourceCount} related resources" }}</span>
        <span class="pill">{{ s!"{repoCount} tracked repos" }}</span>
      </div>
      <h3>"What this area should support"</h3>
      <ul class="clean-list">
        {{ Html.seq nextItems }}
      </ul>
    </section>
  }}

def renderGrantSection (title : String) (items : Array (GrantAward × Option String)) : Html :=
  {{
    <section>
      <h2>{{ title }}</h2>
      <div class="card-grid card-grid--grants">
        {{ Html.seq (items.map fun (grant, href) => renderGrantCard grant href) }}
      </div>
    </section>
  }}

def renderResourceSectionHtml (title : String) (items : Array ResourceItem) : Html :=
  {{
    <section>
      <h2>{{ title }}</h2>
      <div class="card-grid">
        {{ items.map renderResourceCard }}
      </div>
    </section>
  }}

def renderInfoList (title : String) (items : List String) : Html :=
  if items.isEmpty then
    .empty
  else
    let listItems : Array Html := items.toArray.map fun item =>
      Html.tag "li" #[] (Html.ofString item)
    {{
      <section class="detail-card">
        <h3>{{ title }}</h3>
        <ul class="clean-list">
          {{ Html.seq listItems }}
        </ul>
      </section>
    }}

def renderLinkItem (item : LinkItem) : Html :=
  {{
    <li><a href={{ item.url }}>{{ item.label }}</a></li>
  }}

def renderTrackStatus (key : TrackKey) : Html :=
  let track := trackInfo! key
  {{
    <div class="detail-stack">
      <section class="spotlight-card spotlight-card--status">
        <p class="eyebrow">{{ track.key.title }} " status"</p>
        <p class="lead">{{ track.statusHeadline }}</p>
        <p>{{ track.statusSummary }}</p>
      </section>
      <div class="detail-grid">
        {{ renderInfoList "Current Work" track.currentWork }}
        {{ renderInfoList "Next Milestones" track.nextMilestones }}
        {{ renderInfoList "Dependencies" track.dependencies }}
      </div>
    </div>
  }}

def renderTrackOutcomes (key : TrackKey) : HtmlM Page Html := do
  let track := trackInfo! key
  let grantPages := grantCaseStudiesForTrack key
  let grantLinks ←
    if grantPages.isEmpty then
      pure Html.empty
    else
      let links ← grantPages.mapM fun detail => do
        let href ← htmlHrefTo ["grants", "awarded", detail.slug]
        pure {{ <li><a href={{ href }}>{{ detail.awardTitle }}</a></li> }}
      pure {{
        <section class="detail-card">
          <h3>"Related grant outcome pages"</h3>
          <ul class="clean-list">
            {{ Html.seq links }}
          </ul>
        </section>
      }}
  pure {{
    <div class="detail-stack">
      <section class="spotlight-card spotlight-card--outcomes">
        <p class="eyebrow">{{ track.key.title }} " outcomes"</p>
        <p class="lead">{{ track.outcomeSummary }}</p>
      </section>
      <div class="detail-grid">
        {{ renderInfoList "Outcome Themes" track.outcomeThemes }}
        {{ grantLinks }}
      </div>
    </div>
  }}


def renderGrantCaseStudy (slug : String) : Html :=
  match grantCaseStudyOfSlug? slug with
  | none => {{ <p>"Unknown grant outcome page."</p> }}
  | some detail =>
    let relatedTrack := trackInfo! detail.relatedTrack
    let linkItems :=
      if detail.links.isEmpty then
        .empty
      else
        {{
          <section class="detail-card">
            <h3>"Links"</h3>
            <ul class="clean-list">
              {{ detail.links.toArray.map renderLinkItem }}
            </ul>
          </section>
        }}
    {{
      <div class="detail-stack">
        <section class="spotlight-card spotlight-card--warm">
          <p class="eyebrow">{{ relatedTrack.key.title }} " grant outcome"</p>
          <p class="lead">{{ detail.summary }}</p>
          <p>{{ detail.currentState }}</p>
        </section>
        <div class="detail-grid">
          {{ renderInfoList "Outputs" detail.outputs }}
          {{ renderInfoList "Why It Matters" detail.significance }}
          {{ linkItems }}
        </div>
      </div>
    }}

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
    let applyHref ← htmlHrefTo ["grants", "application-guidelines"]
    let awardedHref ← htmlHrefTo ["grants", "awarded"]
    pure {{
      <section class="spotlight-card spotlight-card--warm">
        <p class="eyebrow">"Grants"</p>
        <p class="lead">"Applications are currently open, and the site now separates funding process from funded outcomes."</p>
        <div class="metric-row">
          <span class="pill">{{ s!"{total} recorded awards" }}</span>
          <span class="pill">"application guidelines available"</span>
          <span class="pill">"future outcome pages ready"</span>
        </div>
        <div class="action-row">
          <a href={{ openHref }} class="action-link">"Grant overview"</a>
          <a href={{ applyHref }} class="action-link">"How to apply"</a>
          <a href={{ awardedHref }} class="action-link">"Awarded grants"</a>
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
    let tracksHref ← htmlHrefTo ["project", "tracks"]
    let awardedHref ← htmlHrefTo ["grants", "awarded"]
    pure {{
      <section class="hero-panel">
        <div class="hero-panel__main">
          <p class="eyebrow">"Ethereum Foundation initiative"</p>
          <h1>"Formal verification for zkEVMs, with one place for project context, funded work, and technical outputs."</h1>
          <p class="lead">"The site is organized around three tracks, an awarded-grants archive, and a shared resource library so it can stay readable as documentation grows."</p>
          <div class="action-row">
            <a href={{ projectHref }} class="action-link action-link--primary">"Explore the project"</a>
            <a href={{ tracksHref }} class="action-link">"Browse tracks"</a>
            <a href={{ awardedHref }} class="action-link">"See funded work"</a>
          </div>
        </div>
        <div class="hero-panel__stats">
          <div class="hero-stat">
            <span class="hero-stat__value">{{ toString trackCount }}</span>
            <span class="hero-stat__label">"tracks"</span>
          </div>
          <div class="hero-stat">
            <span class="hero-stat__value">{{ toString grantCount }}</span>
            <span class="hero-stat__label">"recorded awards"</span>
          </div>
          <div class="hero-stat">
            <span class="hero-stat__value">{{ toString resourceCount }}</span>
            <span class="hero-stat__label">"talks, papers, and articles"</span>
          </div>
          <div class="hero-stat">
            <span class="hero-stat__value">{{ toString repoCount }}</span>
            <span class="hero-stat__label">"tracked repositories"</span>
          </div>
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
          let href ← htmlHrefTo ["grants", "awarded", detail.slug]
          pure <| some href
        | none => pure none
      pure <| renderGrantCard grant outcomeHref
    let href ← htmlHrefTo ["grants", "awarded"]
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
              let href ← htmlHrefTo ["grants", "awarded", detail.slug]
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

block_component +directive grant_case_study (slug : String) where
  toHtml _ _ _ _ _ := do
    pure <| renderGrantCaseStudy slug

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
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1rem;
}

.card-grid--tracks {
  margin-top: 1rem;
}

.card-grid--grants {
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
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
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.detail-card {
  border: 1px solid var(--vz-border);
  border-radius: 1rem;
  background: rgba(18, 23, 21, 0.7);
  padding: 1.2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
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
