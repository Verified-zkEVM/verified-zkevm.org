import VersoBlog
import «verified-zkevm»

open Verso Genre Blog Site Syntax

open Output Html Template Theme in
def theme : Theme :=
  { Theme.default with
    primaryTemplate := do
      let postList :=
        match (← param? "posts") with
        | none => Html.empty
        | some html => {{ <section class="post-archive"><h2>"Updates"</h2>{{ html }}</section> }}
      let catList :=
        match (← param? (α := Post.Categories) "categories") with
        | none => Html.empty
        | some ⟨cats⟩ => {{
            <section class="category-directory">
              <h2>"Categories"</h2>
              <ul>
              {{ cats.map fun (target, cat) =>
                {{ <li><a href={{ target }}>{{ Post.Category.name cat }}</a></li> }}
              }}
              </ul>
            </section>
          }}
      let title : String ← param "title"
      let homeHref := String.join ((← currentPath).toList.map (fun _ => "../")) ++ "./"
      pure {{
        <html lang="en">
          <head>
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <meta name="description" content="The zkEVM Formal Verification Project"/>
            <title>{{ title }} " | Verified zkEVMs"</title>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link
              href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600;8..60,700&display=swap"
              rel="stylesheet"
            />
            {{ ← builtinHeader }}
          </head>
          <body>
            <header class="site-header">
              <div class="site-header__inner">
                <a class="site-mark" href={{ homeHref }}>
                  <img src={{ s!"{homeHref}static/eth-diamond-multi.png" }} alt="Verified zkEVMs logo"/>
                  <span>"Verified zkEVMs"</span>
                </a>
                {{ ← VerifiedZkEvmSite.topLevelNav }}
              </div>
            </header>
            <main class="site-main">
              <div class="site-shell">
                {{ ← VerifiedZkEvmSite.sectionNav }}
                {{ ← VerifiedZkEvmSite.breadcrumbs 2 }}
                {{ ← param "content" }}
                {{ catList }}
                {{ postList }}
              </div>
            </main>
          </body>
        </html>
      }}
    ,
    cssFiles := #[("site.css", VerifiedZkEvmSite.siteCss)]
  }
    |>.override #[] {
      template := do
        pure {{
          <article class="frontpage frontpage--home">
            <h1>{{ ← param (α := String) "title" }}</h1>
            {{ ← param "content" }}
          </article>
        }},
      params := id
    }
    |>.override #["project"] {
      template := do
        pure {{
          <article class="landing-page landing-page--project">
            <h1>{{ ← param (α := String) "title" }}</h1>
            {{ ← param "content" }}
          </article>
        }},
      params := id
    }
    |>.override #["project", "tracks"] {
      template := do
        pure {{
          <article class="landing-page landing-page--tracks">
            <h1>{{ ← param (α := String) "title" }}</h1>
            {{ ← param "content" }}
          </article>
        }},
      params := id
    }
    |>.override #["grants"] {
      template := do
        pure {{
          <article class="landing-page landing-page--grants">
            <h1>{{ ← param (α := String) "title" }}</h1>
            {{ ← param "content" }}
          </article>
        }},
      params := id
    }
    |>.override #["resources"] {
      template := do
        pure {{
          <article class="landing-page landing-page--resources">
            <h1>{{ ← param (α := String) "title" }}</h1>
            {{ ← param "content" }}
          </article>
        }},
      params := id
    }

def website : Site := site «verified-zkevm».FrontPage /
  static "static" ← "static_files"
  "project" «verified-zkevm».Project.Index /
    "tracks" «verified-zkevm».Project.Tracks /
      "riscv-zkvm" «verified-zkevm».Tracks.RiscvZkvm
      "evm" «verified-zkevm».Tracks.Evm
      "cryptography" «verified-zkevm».Tracks.Cryptography
  "grants" «verified-zkevm».Grants.Index /
    "rfps" «verified-zkevm».Grants.RFPs
    "application-guidelines" «verified-zkevm».Grants.ApplicationGuidelines
    "awarded" «verified-zkevm».Grants.Awarded /
      "clean" «verified-zkevm».Grants.Awarded.Clean
      "llzk" «verified-zkevm».Grants.Awarded.LLZK
      "arklib" «verified-zkevm».Grants.Awarded.ArkLib
  "resources" «verified-zkevm».Resources.Index /
    "repositories" «verified-zkevm».Resources.Repositories
    "talks-and-videos" «verified-zkevm».Resources.Talks
    "articles" «verified-zkevm».Resources.Articles
    "papers" «verified-zkevm».Resources.Papers
  "docs" «verified-zkevm».Docs
  "updates" «verified-zkevm».Updates
  "contact" «verified-zkevm».Contact

def main := blogMain theme website
