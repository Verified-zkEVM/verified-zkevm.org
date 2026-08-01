import VersoBlog
import «verified-zkevm».Data
import «verified-zkevm».Routing

open Verso Genre Blog
open Verso.Output
open Verso.Output.Html
open Verso.Doc.Html

namespace VerifiedZkEvmSite

def metaLine (date source : String) : String :=
  match date.isEmpty, source.isEmpty with
  | true, true => ""
  | false, true => date
  | true, false => source
  | false, false => s!"{date} · {source}"

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

def renderGrantLink (grant : GrantAward) : Html :=
  match grant.url, grant.urlLabel with
  | some url, some label => {{ <a href={{ url }} class="mini-link">{{ label }}</a> }}
  | some url, none => {{ <a href={{ url }} class="mini-link">"Link"</a> }}
  | none, _ => .empty

def renderGrantCard (grant : GrantAward) : Html :=
  let periodHtml :=
    match grant.period with
    | some period => {{ <span class="pill">{{ period }}</span> }}
    | none => .empty
  let outputHtml :=
    match grant.output with
    | some output =>
      {{ <p class="supporting"><strong>"Output: "</strong>{{ output }}</p> }}
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
      {{ outputHtml }}
      {{ renderGrantLink grant }}
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
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Read article"</a>
      }}
    | .paper =>
      {{
        <div class="metric-row">
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Read paper"</a>
      }}
    | .talk =>
      {{
        <div class="metric-row">
          {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
        </div>
        <a href={{ item.url }} class="mini-link">"Watch video"</a>
      }}
    | .repo =>
      let codeLink := {{ <a href={{ item.url }} class="mini-link">"GitHub repository"</a> }}
      {{
        <div class="metric-row">
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

def renderGrantSection (title : String) (items : Array GrantAward) : Html :=
  {{
    <section>
      <h2>{{ title }}</h2>
      <div class="card-grid card-grid--grants">
        {{ Html.seq (items.map renderGrantCard) }}
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

def renderResourceSectionWithNote (title note : String) (items : Array ResourceItem) : Html :=
  {{
    <section>
      <h2>{{ title }}</h2>
      <p class="section-note">{{ note }}</p>
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

def renderTrackOverview (key : TrackKey) : Html :=
  let track := trackInfo! key
  let paragraphs : Array Html := track.overview.toArray.map fun para =>
    Html.tag "p" #[] (Html.ofString para)
  {{
    <div class="detail-stack">
      <section class="spotlight-card spotlight-card--overview">
        <p class="eyebrow">{{ track.key.title }} " overview"</p>
        {{ Html.seq paragraphs }}
      </section>
    </div>
  }}


end VerifiedZkEvmSite
