import VersoBlog

open Verso Genre Blog
open Template
open Verso.Output.Html

namespace VerifiedZkEvmSite

def articleTemplate (classNames : String) : Template := do
  pure {{
    <article class={{ classNames }}>
      <h1>{{ ← param (α := String) "title" }}</h1>
      {{ ← param "content" }}
    </article>
  }}

end VerifiedZkEvmSite
