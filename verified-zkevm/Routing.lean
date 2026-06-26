import VersoBlog

open Verso Genre Blog
open Template
open Verso.Output.Html

namespace VerifiedZkEvmSite

def hrefTo (segments : List String) : TemplateM String := do
  if segments.isEmpty then
    pure "./"
  else
    pure <| String.join (segments.map (· ++ "/"))

def currentRoot? : TemplateM (Option String) := do
  pure <| (← currentPath).toList.head?

def pathActive (segments : List String) : TemplateM Bool := do
  pure <| (← currentPath).toList == segments

def rootActive (root : String) : TemplateM Bool := do
  pure <| (← currentRoot?) == some root

def absoluteHref (segments : List String) : String :=
  match segments with
  | [] => "/"
  | _ => "/" ++ String.intercalate "/" segments ++ "/"

def htmlHrefTo (target : List String) : HtmlM Page String := do
  if target.isEmpty then
    pure "./"
  else
    pure <| String.join (target.map (· ++ "/"))

end VerifiedZkEvmSite
