import VersoBlog

open Verso Genre Blog

namespace VerifiedZkEvmSite

/--
Link to a page identified by its path segments from the site root.

Every page carries a `<base href>` pointing at the site root (see `siteHeader`), so hrefs are
written root-relative and need no knowledge of where the linking page sits. That keeps link
construction a plain function instead of something that has to run in a monad.
-/
def hrefTo : List String → String
  | [] => "./"
  | segments => String.join (segments.map (· ++ "/"))

/-- Whether the page being rendered is exactly `segments`. -/
def pathActive [Monad m] [MonadPath m] (segments : List String) : m Bool := do
  return (← currentPath).toList == segments

/-- Whether the page being rendered lives anywhere under the top-level section `root`. -/
def rootActive [Monad m] [MonadPath m] (root : String) : m Bool := do
  return (← currentPath).toList.head? == some root

end VerifiedZkEvmSite
