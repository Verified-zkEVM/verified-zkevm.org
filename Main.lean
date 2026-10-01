import VersoBlog
import «verified-zkevm»

open Verso Genre Blog Site Syntax
open VerifiedZkEvmSite

def siteName := "Verified zkEVMs"

def siteDescription :=
  "The Ethereum Foundation's project on formal verification for zkEVMs: tracks, awarded grants, \
   and a library of talks, papers, articles, and repositories."

open Output Html Template Theme in
def theme : Theme :=
  { Theme.default with
    primaryTemplate := do
      let title : String ← param "title"
      -- The front page is titled after the site, so the name is not repeated in the tab title.
      let documentTitle := if title == siteName then siteName else s!"{title} | {siteName}"
      let logo := s!"{hrefTo []}static/eth-diamond-multi.png"
      return {{
        <html lang="en">
          <head>
            <meta charset="utf-8"/>
            {{ ← siteBase }}
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <meta name="description" content={{ siteDescription }}/>
            <meta name="theme-color" content="#0a0d0b"/>
            <title>{{ documentTitle }}</title>
            <meta property="og:type" content="website"/>
            <meta property="og:site_name" content={{ siteName }}/>
            <meta property="og:title" content={{ documentTitle }}/>
            <meta property="og:description" content={{ siteDescription }}/>
            <meta name="twitter:card" content="summary"/>
            <link rel="icon" href={{ logo }}/>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link
              href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@400;500;600;700&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600;8..60,700&display=swap"
              rel="stylesheet"
            />
            {{ ← siteHeader }}
            {{ if title == siteName then
              {{ <script src="static/legacy-links.js" defer="defer"></script> }}
              else .empty }}
          </head>
          <body>
            <header class="site-header">
              <div class="site-header__inner">
                <a class="site-mark" href={{ hrefTo [] }}>
                  <img src={{ logo }} alt="" width="32" height="32"/>
                  <span>{{ siteName }}</span>
                </a>
                {{ ← topLevelNav }}
              </div>
            </header>
            <main class="site-main">
              <div class="site-shell">
                {{ ← sectionNav }}
                {{ ← param "content" }}
              </div>
            </main>
            {{ siteFooter }}
          </body>
        </html>
      }}
    ,
    cssFiles := #[("site.css", siteCss)]
  }
    -- Every page uses Verso's default article template (`<h1>` from the title, then the content).
    -- Only the front page differs: its hero supplies the heading.
    |>.override #[] { template := frontPageTemplate, params := id }

def website : Site := site «verified-zkevm».FrontPage /
  static "static" ← "static_files"
  "project" «verified-zkevm».Project.Index /
    "zkvm" «verified-zkevm».Tracks.RiscvZkvm
    "evm" «verified-zkevm».Tracks.Evm
    "cryptography" «verified-zkevm».Tracks.Cryptography
  "grants" «verified-zkevm».Grants.Index
  "resources" «verified-zkevm».Resources.Index
  "contact" «verified-zkevm».Contact

def main := blogMain theme website
