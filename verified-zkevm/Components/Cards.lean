import VersoBlog
import «verified-zkevm».Data
import «verified-zkevm».Routing

open Verso Genre Blog
open Verso.Output
open Verso.Output.Html
open Verso.Doc.Html

namespace VerifiedZkEvmSite

/--
A card's title heading.

Cards appear at different depths on different pages — a grant card sits under `h1 → h2 → h3` on
the grants page but under `h1 → h2` on a track page — so the level travels with the call site to
keep the document outline gap-free. The stylesheet sizes headings by the enclosing card class, so
the level carries semantics only and never changes how the card looks.
-/
def cardTitle (level : Nat) (content : Html) : Html :=
  Html.tag s!"h{level}" #[] content

def metaLine (date source : String) : String :=
  match date.isEmpty, source.isEmpty with
  | true, true => ""
  | false, true => date
  | true, false => source
  | false, false => s!"{date} · {source}"

/-- An inline `Label: a, b, c` list, used for the track tags on a resource card. -/
def renderInfoListCompact (title : String) (items : List String) : Html :=
  if items.isEmpty then
    .empty
  else
    let listItems : Array Html := items.toArray.map fun item =>
      Html.tag "li" #[] (Html.ofString item)
    {{
      <div class="info-list">
        <strong>{{ title }}": "</strong>
        <ul>{{ Html.seq listItems }}</ul>
      </div>
    }}

def renderGrantLink (grant : GrantAward) : Html :=
  match grant.url, grant.urlLabel with
  | some url, some label => {{ <a href={{ url }} class="mini-link">{{ label }}</a> }}
  | some url, none => {{ <a href={{ url }} class="mini-link">"Link"</a> }}
  | none, _ => .empty

def renderGrantCard (level : Nat) (grant : GrantAward) : Html :=
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
        {{ cardTitle level grant.title }}
        <div class="meta-row">
          {{ periodHtml }}
        </div>
      </div>
      <p>{{ grant.description }}</p>
      <div class="card-foot">
        <p class="supporting">
          <strong>"Awarded to: "</strong>{{ grant.awardedTo }}
        </p>
        {{ outputHtml }}
        {{ renderGrantLink grant }}
      </div>
    </article>
  }}

/-- The call to action on a resource card, phrased for the kind of resource it links to. -/
def ResourceKind.linkLabel : ResourceKind → String
  | .article => "Read article"
  | .paper => "Read paper"
  | .talk => "Watch video"
  | .repo => "GitHub repository"

def renderResourceCard (level : Nat) (item : ResourceItem) : Html :=
  let metaText := metaLine item.dateLabel item.sourceLabel
  let metaHtml :=
    if metaText.isEmpty then .empty
    else {{ <p class="supporting">{{ metaText }}</p> }}
  let blurb :=
    match item.blurb? with
    | some blurbText => {{ <p class="supporting">{{ blurbText }}</p> }}
    | none => .empty
  let trackTags :=
    if item.trackTags.isEmpty then .empty
    else {{
      <div class="metric-row">
        {{ renderInfoListCompact "Tracks" (item.trackTags.map TrackKey.title) }}
      </div>
    }}
  {{
    <article class="resource-card">
      {{ metaHtml }}
      {{ cardTitle level item.title }}
      {{ blurb }}
      <div class="card-foot">
        {{ trackTags }}
        <a href={{ item.url }} class="mini-link">{{ item.kind.linkLabel }}</a>
      </div>
    </article>
  }}

/-- The counts shown on a track tile and in the track spotlight. -/
private def trackCounts (key : TrackKey) : Nat × Nat × Nat :=
  let items := resourcesForTrack key
  ((grantsForTrack key).size,
   (items.filter (·.kind != .repo)).size,
   (items.filter (·.kind == .repo)).size)

/--
Teaser for a track, linking to its page.

The tile carries the track's name and one-line summary only; `focus` is the longer framing and
belongs on the track page itself, where the spotlight already shows it. Keeping the tile to a
fixed set of short fields is what lets a row of tiles stay the same height.
-/
def renderTrackTile (level : Nat) (track : TrackInfo) : Html :=
  let href := hrefTo track.key.path
  let (grantCount, resourceCount, repoCount) := trackCounts track.key
  {{
    <article class="track-tile">
      {{ cardTitle level {{ <a href={{ href }}>{{ track.key.title }}</a> }} }}
      <p>{{ track.summary }}</p>
      <div class="card-foot">
        <div class="metric-row">
          <span class="pill">{{ s!"{grantCount} grants" }}</span>
          <span class="pill">{{ s!"{resourceCount} resources" }}</span>
          <span class="pill">{{ s!"{repoCount} repos" }}</span>
        </div>
        <a href={{ href }} class="mini-link">"Explore track"</a>
      </div>
    </article>
  }}

/--
Opens a track page: the one-line summary as a standfirst, then what the track has to show for
itself so far.

This is page prose, not a card. Wrapping it in a panel would put a box around body text and
compete with the cards further down, which are the only things on the site that are panels.
-/
def renderTrackHeader (key : TrackKey) : Html :=
  let track := trackInfo! key
  let (grantCount, resourceCount, repoCount) := trackCounts key
  {{
    <div>
      <p class="lead">{{ track.summary }}</p>
      <div class="metric-row">
        <span class="pill">{{ s!"{grantCount} awarded grants" }}</span>
        <span class="pill">{{ s!"{resourceCount} related resources" }}</span>
        <span class="pill">{{ s!"{repoCount} tracked repos" }}</span>
      </div>
    </div>
  }}

/--
The track's prose: what it covers, followed by where the work currently stands.

`focus` and `overview` are consecutive paragraphs of one narrative rather than two separately
framed blocks — they were previously rendered as two near-identical cards, and for some tracks
they still say much the same thing.
-/
def renderTrackOverview (key : TrackKey) : Html :=
  let track := trackInfo! key
  let paragraphs : Array Html := ((track.focus :: track.overview).filter fun para => !para.isEmpty).toArray.map fun para =>
    Html.tag "p" #[] (Html.ofString para)
  {{ <div>{{ Html.seq paragraphs }}</div> }}

/-- The track's verification goals, as a plain list under its own heading. -/
def renderTrackGoals (key : TrackKey) : Html :=
  let items : Array Html := (trackInfo! key).verificationGoals.toArray.map fun item =>
    Html.tag "li" #[] (Html.ofString item)
  {{ <ul class="clean-list">{{ Html.seq items }}</ul> }}

/--
A headed group of cards.

`level` is the heading level of the group itself; the cards inside sit one level below it.
-/
def renderCardSection (level : Nat) (title : String) (note : Option String) (cards : Array Html)
    (gridClass : String := "card-grid") : Html :=
  let noteHtml :=
    match note with
    | some noteText => {{ <p class="section-note">{{ noteText }}</p> }}
    | none => .empty
  {{
    <section>
      {{ Html.tag s!"h{level}" #[] title }}
      {{ noteHtml }}
      <div class={{ gridClass }}>{{ Html.seq cards }}</div>
    </section>
  }}

def renderGrantSection (level : Nat) (title : String) (items : Array GrantAward) : Html :=
  renderCardSection level title none (items.map (renderGrantCard (level + 1)))
    "card-grid card-grid--grants"

def renderResourceSection (level : Nat) (title : String) (note : Option String)
    (items : Array ResourceItem) : Html :=
  renderCardSection level title note (items.map (renderResourceCard (level + 1)))

end VerifiedZkEvmSite
