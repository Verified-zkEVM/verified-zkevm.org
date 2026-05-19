namespace VerifiedZkEvmSite

inductive TrackKey where
  | riscvZkvm
  | evm
  | cryptography
deriving BEq, DecidableEq, Inhabited, Repr

def TrackKey.slug : TrackKey → String
  | .riscvZkvm => "riscv-zkvm"
  | .evm => "evm"
  | .cryptography => "cryptography"

def TrackKey.title : TrackKey → String
  | .riscvZkvm => "RISC-V zkVM"
  | .evm => "EVM"
  | .cryptography => "Cryptography"

def TrackKey.path : TrackKey → List String
  | t => ["project", "tracks", t.slug]

def trackKeyOfSlug? (slug : String) : Option TrackKey :=
  match slug with
  | "riscv-zkvm" => some .riscvZkvm
  | "evm" => some .evm
  | "cryptography" => some .cryptography
  | _ => none

structure TrackInfo where
  key : TrackKey
  summary : String
  focus : String
  statusHeadline : String
  statusSummary : String
  currentWork : List String
  nextMilestones : List String
  dependencies : List String
  outcomeSummary : String
  outcomeThemes : List String
  whatNext : List String
deriving Repr, Inhabited

def tracks : Array TrackInfo := #[
  {
    key := .riscvZkvm
    summary := "Verification of zkVM arithmetizations against the official RISC-V Sail semantics."
    focus := "This track covers circuit semantics, extraction and comparison against machine specifications, and tooling that makes zkVM verification maintainable."
    statusHeadline := "The track is moving from general infrastructure grants into more concrete verification workflows and comparison tooling."
    statusSummary := "Current work is concentrated around extraction from machine specifications, verification of concrete circuit artifacts, and tooling that makes zkVM verification repeatable across implementations."
    currentWork := [
      "comparing AIR/circuit constraints against machine-level semantics",
      "improving toolchains such as LLZK and cLean so verification work is easier to express and maintain",
      "building automated testing and fuzzing workflows around zkVM implementations"
    ]
    nextMilestones := [
      "track-specific status notes for major zkVM efforts",
      "clearer mappings from grants to artefacts and repositories",
      "documentation around verification methodology for RISC-V zkVM components"
    ]
    dependencies := [
      "reliable extraction from the Sail RISC-V specification",
      "maintained intermediate representations for circuits and constraints",
      "shared tooling for relating witness generation, constraints, and machine semantics"
    ]
    outcomeSummary := "The strongest outcomes so far are infrastructure-heavy: circuit DSLs, MLIR-based intermediate representations, fuzzing and bug-finding work, and early formal verification reports around concrete zkVM components."
    outcomeThemes := [
      "verification-oriented infrastructure rather than one-off proofs",
      "intermediate representations and tooling that can be reused across zkVMs",
      "artefacts that connect specifications, circuits, and implementation testing"
    ]
    whatNext := [
      "track status summaries",
      "grant-linked outcomes",
      "artefact links and repository notes",
      "track-specific technical documentation"
    ]
  },
  {
    key := .evm
    summary := "Verification that EVM implementations on RISC-V correctly realize the EVM specification."
    focus := "This track sits at the boundary between language semantics, implementations, and compilation paths that matter for zkVM targets."
    statusHeadline := "The EVM track is narrower than the zkVM infrastructure track, but it already has a clear technical center of gravity."
    statusSummary := "Work here is focused on maintaining executable and validated EVM specifications, relating existing semantics frameworks, and verifying practical implementations that target RISC-V and zkVM environments."
    currentWork := [
      "maintaining or improving EVM specifications in Rocq and related frameworks",
      "connecting KEVM-style semantics with executable and verification-friendly backends",
      "verifying concrete implementation paths such as revm compiled to RISC-V"
    ]
    nextMilestones := [
      "clear status notes on the state of canonical EVM specifications",
      "better documentation of how implementation verification relates to zkVM targets",
      "consolidated outcomes across the certified compilation and revm workstreams"
    ]
    dependencies := [
      "stable EVM semantics with credible validation against real implementations",
      "bridges between existing semantics frameworks and Lean/Rocq-based verification tooling",
      "clarity on which execution paths matter most for zkVM deployment"
    ]
    outcomeSummary := "The current outcomes are specification and semantics oriented: canonical EVM modeling, work on certified compilation, and verification paths tying existing implementation ecosystems back to trusted semantics."
    outcomeThemes := [
      "specification quality and maintainability",
      "verification of practical implementation paths instead of abstract models alone",
      "tooling that lets semantics work feed into zkVM-relevant execution targets"
    ]
    whatNext := [
      "status and dependency notes",
      "links to reference specifications",
      "grant outcomes relevant to EVM correctness",
      "implementation-focused documentation"
    ]
  },
  {
    key := .cryptography
    summary := "Verification of proof systems, security arguments, and cryptographic components used by zkVMs and zkEVMs."
    focus := "This track connects executable specifications, proof libraries, and formalized security reasoning for the cryptographic core of the stack."
    statusHeadline := "The cryptography track has the clearest library-centered outcome story so far, with ArkLib acting as a visible focal point."
    statusSummary := "Current work spans executable specifications for proof-system components, foundations for security arguments, and Lean-based tooling needed to make proof-system verification and cryptographic reasoning cumulative."
    currentWork := [
      "formalizing proof-system components and prerequisite mathematics in ArkLib",
      "developing executable specifications for constructions such as Fiat-Shamir, STIR, WHIR, and Binius-related work",
      "exploring better proof engineering workflows, including Lean tooling and AI-assisted proof experiments"
    ]
    nextMilestones := [
      "better reporting on which cryptographic components already have executable specifications",
      "clearer links from grants to papers, talks, and repositories around ArkLib",
      "more explicit documentation of dependencies between security blueprints and library code"
    ]
    dependencies := [
      "robust mathematical prerequisites for coding theory and proof-system arguments",
      "library structure that supports both executable specs and proof-oriented abstractions",
      "maintained links between research outputs, grants, and formalized artefacts"
    ]
    outcomeSummary := "This track already has visible outputs in the form of ArkLib, papers, talks, and specification-oriented grants. The main value now is consolidating those outputs into a clearer map of what has been formalized and what remains open."
    outcomeThemes := [
      "library-first accumulation of formalized proof-system knowledge",
      "security blueprints and executable specifications moving in parallel",
      "strong outward-facing outputs through talks, articles, and papers"
    ]
    whatNext := [
      "security-proof and specification notes",
      "grant outcomes around ArkLib and related tooling",
      "links to talks, articles, and papers",
      "documentation around proof-system components"
    ]
  }
]

def trackInfo! (key : TrackKey) : TrackInfo :=
  match tracks.find? (·.key == key) with
  | some info => info
  | none => panic! s!"Missing track data for {repr key}"

structure GrantAward where
  group : String
  relatedTrack : Option TrackKey := none
  title : String
  description : String
  awardedTo : String
  period : Option String := none
  url : Option String := none
  urlLabel : Option String := none
deriving Repr

structure LinkItem where
  label : String
  url : String
deriving Repr

structure GrantCaseStudy where
  slug : String
  awardTitle : String
  relatedTrack : TrackKey
  summary : String
  currentState : String
  outputs : List String
  significance : List String
  links : List LinkItem := []
deriving Repr

def grants : Array GrantAward := #[
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Verifying autoprecompiles"
    description := "Intended to support the verification of Powdr Labs' autoprecompiles."
    awardedTo := "Powdr Labs GmbH, Certora"
    period := some "Q4 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "AVAZAR: Automatic verification tools for zkVM arithmetization"
    description := "Intended to support work on automated verification tools for zkVM arithmetizations."
    awardedTo := "Universidad Complutense de Madrid (Albert Rubio)"
    period := some "Q4 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "ZKVM Agnostic Fuzzing"
    description := "Intended to support the development of fuzzing techniques applicable to any RISC-V zkVM."
    awardedTo := "zksecurity"
    period := some "Q3 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "zkBugs 2.0"
    description := "Intended to support an update of zkBugs."
    awardedTo := "zksecurity"
    period := some "Q3 2025"
    url := some "https://bugs.zksecurity.xyz"
    urlLabel := some "zkBugs"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Automated Verification of ZK Circuits"
    description := "Intended to support the development of techniques to automatically verify the consistency between witness generation and constraints."
    awardedTo := "Veridise"
    period := some "Q3 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "ZKarnage: Stress Testing ZK Systems Through Maximum Pain"
    description := "Intended to support work on prover killers."
    awardedTo := "Conner Swann"
    period := some "Q2 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Plonky3 in Rocq"
    description := "Intended to support an integration of Plonky3 with Rocq."
    awardedTo := "Formal Land"
    period := some "Q2 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Plonky3 to Lean"
    description := "Intended to support an integration of Plonky3 with Lean."
    awardedTo := "Nethermind"
    period := some "Q1 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Evaluating Verus for circuits and EVM precompiles"
    description := "Intended to support an evaluation of Verus as a tool to verify representative Rust code."
    awardedTo := "CertiK"
    period := some "Q1 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Better Rocq tactics for modular arithmetic & handling packed integers"
    description := "Intended to support the development of Rocq tactics for handling arithmetic modulo and packed integers."
    awardedTo := "CertiK"
    period := some "Q1 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "cLean"
    description := "Intended to support the development of a Lean DSL aimed at writing AIR circuits directly in Lean."
    awardedTo := "zkSecurity"
    period := some "Q4 2025"
    url := some "https://github.com/Verified-zkEVM/clean"
    urlLabel := some "Repository"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "LLZK"
    description := "Intended to support the development of LLZK, a family of MLIR dialects for circuits."
    awardedTo := "Veridise"
    period := some "Q4 2024, Q4 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "Lean backend for Sail"
    description := "Intended to support a Lean backend for Sail so that the official RISC-V Sail specification can be extracted to Lean."
    awardedTo := "University of Cambridge, Galois, Lindy Labs (first grant only)"
    period := some "Q1 2025, Q3 2025"
  },
  {
    group := "RISC-V zkVM Track"
    relatedTrack := some .riscvZkvm
    title := "zkLean"
    description := "Intended to support a Lean DSL for constraints and its integration with LLZK."
    awardedTo := "Galois"
    period := some "Q1 2025, Q3 2025"
  },
  {
    group := "EVM Track"
    relatedTrack := some .evm
    title := "Certified compilation"
    description := "Intended to support research on certified compilation methods in the Rocq ecosystem together with tools for high-assurance cryptography."
    awardedTo := "Aarhus University"
    period := some "Q4 2024"
  },
  {
    group := "EVM Track"
    relatedTrack := some .evm
    title := "Development of an EVM in Rocq"
    description := "Intended to support the development of a canonical, maintainable, and validated EVM specification in Rocq."
    awardedTo := "KTH Royal Institute of Technology"
    period := some "Q4 2024"
  },
  {
    group := "EVM Track"
    relatedTrack := some .evm
    title := "Verification of revm and Lean backend for K"
    description := "Intended to support verification of revm compiled to RISC-V against KEVM together with development of a Lean backend for K."
    awardedTo := "Runtime Verification"
    period := some "Q4 2024"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Technical Review of Fiat-Shamir From Duplex Sponges"
    description := "Intended to support a technical review of the Fiat-Shamir transformation instantiated via duplex sponges."
    awardedTo := "University of Maryland (Kasra Abbaszadeh)"
    period := some "Q4 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Rust Verification Through Lean 4 Tooling"
    description := "Intended to support investigation into Lean 4 based formal verification of Rust components used in zkEVM and zkVM stacks."
    awardedTo := "Runtime Verification"
    period := some "Q4 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "STIR & WHIR constructions in ArkLib"
    description := "Intended to support the addition of executable specifications for STIR and WHIR in ArkLib."
    awardedTo := "Nethermind"
    period := some "Q4 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Fiat-Shamir specification"
    description := "Intended to support the development of a Fiat-Shamir specification based on duplex sponges."
    awardedTo := "Article 12, LLC (Michele Orrù)"
    period := some "Q4 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Bluebell"
    description := "Intended to support implementation of the Bluebell program logic in Lean for use in ArkLib."
    awardedTo := "Nethermind"
    period := some "Q3 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "AI proofs in ArkLib"
    description := "Intended to support experiments in using Logical Intelligence's AI tools for proofs in ArkLib."
    awardedTo := "Logical Intelligence"
    period := some "Q3 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Binius in ArkLib"
    description := "Intended to support the formalization of Binius in ArkLib."
    awardedTo := "Chung Thai Nguyen"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Blueprint STIR and WHIR in ArkLib"
    description := "Intended to support development of a blueprint for STIR and WHIR security theorems in ArkLib."
    awardedTo := "Least Authority"
    period := some "Q1 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "Blueprint for FRI & Coding Theory prerequisites in ArkLib"
    description := "Intended to support development of a blueprint for FRI and coding theory prerequisites in ArkLib."
    awardedTo := "Nethermind"
    period := some "Q1 2025"
  },
  {
    group := "Cryptography Track"
    relatedTrack := some .cryptography
    title := "ArkLib"
    description := "Intended to support development of ArkLib, a library of formalized proof systems in Lean, together with work on VCVio."
    awardedTo := "Quang Dao, Devon Tuma, zkSecurity"
    period := some "Q4 2024"
    url := some "https://github.com/Verified-zkEVM/ArkLib"
    urlLabel := some "ArkLib"
  },
  {
    group := "General Tooling"
    title := "MLIR sidekick for Lean"
    description := "Intended to support Lean-MLIR infrastructure development, including fast datastructures and a RISC-V dialect in Lean."
    awardedTo := "University of Cambridge"
    period := some "Q3 2025"
  },
  {
    group := "General Tooling"
    title := "Lean backend for hax"
    description := "Intended to support development of a Lean backend for hax."
    awardedTo := "Cryspen"
    period := some "Q2 2025, Q4 2025"
    url := some "https://github.com/cryspen/hax"
    urlLabel := some "hax"
  },
  {
    group := "Events"
    title := "HACS 2026"
    description := "Support for HACS 2026 in March 2026."
    awardedTo := "Aspiration"
    period := some "Q1 2026"
    url := some "https://www.hacs-workshop.org/data/HACS_2026_Overview.pdf"
    urlLabel := some "Overview"
  },
  {
    group := "Events"
    title := "HACS 2025"
    description := "Support for HACS 2025 in March 2025."
    awardedTo := "Aspiration"
    period := some "Q1 2025"
    url := some "https://www.hacs-workshop.org/data/HACS_2025_Overview.pdf"
    urlLabel := some "Overview"
  },
  {
    group := "Events"
    title := "ZKProofs 7"
    description := "Support for ZKProofs 7 in March 2025."
    awardedTo := "ZKProofs"
    period := some "Q1 2025"
    url := some "https://zkproof.org/events/zkproof-7-sofia"
    urlLabel := some "Event"
  },
  {
    group := "Events"
    title := "ZKProofs Zurich Event"
    description := "Support for a Zurich event discussing the formal verification of proof systems."
    awardedTo := "ZKProofs"
    period := some "Q4 2024"
    url := some "https://zkproof.org/verifier"
    urlLabel := some "Summary"
  },
  {
    group := "Community Resources and Education"
    title := "Foundations of Probabilistic Proofs MOOC"
    description := "Intended to support development of a MOOC on the foundations of probabilistic proofs."
    awardedTo := "Algorithmic Security GmbH (Alessandro Chiesa)"
    period := some "Q3 2025"
  },
  {
    group := "Community Resources and Education"
    title := "EthProofs"
    description := "Intended to support continued development of ethproofs.org."
    awardedTo := "Fara Woolf"
    period := some "Q2 2025, Q3 2025"
  }
]

def grantSectionOrder : List String := [
  "RISC-V zkVM Track",
  "EVM Track",
  "Cryptography Track",
  "General Tooling",
  "Events",
  "Community Resources and Education"
]

def grantCaseStudies : Array GrantCaseStudy := #[
  {
    slug := "clean"
    awardTitle := "cLean"
    relatedTrack := .riscvZkvm
    summary := "cLean is intended to make circuit-oriented specifications expressible directly in Lean, so verification work can stay closer to the proof assistant rather than being spread across separate DSLs and ad hoc translations."
    currentState := "This is best understood as enabling infrastructure: the point is not only one codebase, but a better path for specifying AIR-like constraints and connecting them to other tooling in the ecosystem."
    outputs := [
      "a Lean-oriented DSL for writing verification-relevant circuit descriptions",
      "a concrete repository that can anchor follow-on documentation and examples",
      "a bridge between grant funding and future track documentation around Lean-native circuit work"
    ]
    significance := [
      "reduces friction for teams that want Lean-native verification workflows",
      "gives the RISC-V zkVM track a reusable artefact rather than a one-off report",
      "fits the broader effort to make circuit verification infrastructure cumulative"
    ]
    links := [
      { label := "Repository", url := "https://github.com/Verified-zkEVM/clean" }
    ]
  },
  {
    slug := "llzk"
    awardTitle := "LLZK"
    relatedTrack := .riscvZkvm
    summary := "LLZK is a family of MLIR dialects for circuits intended to support shared infrastructure for representing and verifying zero-knowledge artefacts."
    currentState := "The grant’s main value is architectural: it creates a reusable intermediate layer that can support translation, analysis, and verification workflows across multiple circuit systems."
    outputs := [
      "an MLIR-based representation strategy for zero-knowledge circuits",
      "a growing repository ecosystem around LLZK tooling",
      "a foundation for verification flows that do not depend on one source language or proving stack"
    ]
    significance := [
      "helps separate circuit verification from source-language churn",
      "supports interoperability between tooling efforts funded by different grants",
      "is one of the clearest examples of infrastructure with cross-project leverage"
    ]
    links := [
      { label := "LLZK Library", url := "https://github.com/project-llzk/llzk-lib" },
      { label := "LLZK Rust Tooling", url := "https://github.com/project-llzk/llzk-rs" }
    ]
  },
  {
    slug := "arklib"
    awardTitle := "ArkLib"
    relatedTrack := .cryptography
    summary := "ArkLib is the clearest library-centered outcome in the cryptography track: a growing body of formalized proof-system components, specifications, and related supporting infrastructure in Lean."
    currentState := "ArkLib already acts as a focal point for multiple grants, talks, and research outputs. The next documentation step is to make that accumulation legible by connecting grants, components, and published outputs more explicitly."
    outputs := [
      "a public repository for proof-system and cryptographic formalization work",
      "a visible accumulation point for grants involving FRI, Fiat-Shamir, STIR, WHIR, and related topics",
      "a concrete anchor for track-level documentation in the cryptography section"
    ]
    significance := [
      "turns otherwise fragmented cryptography grants into a coherent library story",
      "supports cumulative formalization rather than isolated proofs",
      "creates a natural home for future specifications, blueprints, and component documentation"
    ]
    links := [
      { label := "Repository", url := "https://github.com/Verified-zkEVM/ArkLib" }
    ]
  }
]

inductive ResourceKind where
  | talk
  | article
  | paper
  | repo
deriving BEq, DecidableEq, Inhabited, Repr

def ResourceKind.title : ResourceKind → String
  | .talk => "Talks and Videos"
  | .article => "Articles"
  | .paper => "Papers"
  | .repo => "Repositories"

def resourceKindOfString? (s : String) : Option ResourceKind :=
  match s with
  | "talk" | "talks" => some .talk
  | "article" | "articles" => some .article
  | "paper" | "papers" => some .paper
  | "repo" | "repos" | "repositories" => some .repo
  | _ => none

structure ResourceItem where
  kind : ResourceKind
  title : String
  url : String
  dateLabel : String := ""
  sourceLabel : String := ""
  blurb? : Option String := none
  trackTags : List TrackKey := []
  featured : Bool := false
deriving Repr

def resources : Array ResourceItem := #[
  {
    kind := .talk
    dateLabel := "April 2026"
    title := "Yoichi Hirai - Your guide to formal verification when machines write Lean proofs"
    url := "https://www.youtube.com/watch?v=ciZZRyN26Dg"
    trackTags := [.cryptography]
    featured := true
  },
  {
    kind := .talk
    dateLabel := "April 2026"
    title := "Derek Sorensen - Safely Snarkifying Ethereum: Formal Verification and Protocol"
    url := "https://youtu.be/-1FTm10m2V0?si=35z_cKAzvJAqXORK"
    trackTags := [.cryptography]
    featured := true
  },
  {
    kind := .talk
    dateLabel := "March 2026"
    title := "Manuel Puebla - AMO-Lean"
    url := "https://youtu.be/seCiuBS7Eb0?si=k-1aLYl0zQdZtIMo"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "March 2026"
    title := "Eske Nielsen - Peregrine"
    url := "https://www.youtube.com/watch?v=0MI4U-g9Gus"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "February 2026"
    title := "Bas Spitters - SSProve-Lean"
    url := "https://www.youtube.com/watch?v=vM3USOH1yWw"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "February 2026"
    title := "Julian Sutherland - FRI in ArkLib + Yoichi Hirai - Vibe FRI RBR soundness"
    url := "https://youtu.be/tFbTc6fpCNc"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "January 2026"
    title := "Coding Theory in ArkLib"
    url := "https://www.youtube.com/watch?v=K4TqxUznYLo"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "January 2026"
    title := "ArkLib"
    url := "https://youtu.be/4aVI7MS0S4g"
    trackTags := [.cryptography]
    featured := true
  },
  {
    kind := .talk
    dateLabel := "December 2025"
    title := "Formally Verifying the SP1 RISC-V AIRs"
    url := "https://youtu.be/4VnolGW-iv4"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "November 2025"
    title := "Securing Ethereum: The ZK-EVM Formal Verification Project"
    url := "https://youtu.be/jbCDHb4GMUw?si=O_VArNnHyDZyVp77"
    featured := true
  },
  {
    kind := .talk
    dateLabel := "October 2025"
    title := "Walkthrough of ArkLib"
    url := "https://youtu.be/xmvySCWZwN8?si=HNayiIjqy2G0sMih"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "October 2025"
    title := "pq2-05: e2e Formal Verification"
    url := "https://youtu.be/muryYp1ZIO8?si=9LwsDPydNwIO1Vt2"
    trackTags := [.evm]
  },
  {
    kind := .talk
    dateLabel := "October 2025"
    title := "Comparing ZK Constraints - Keccak, Plonky3 - Rust/Rocq"
    url := "https://www.youtube.com/watch?v=53BXAxY7ThQ"
    trackTags := [.evm, .riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "September 2025"
    title := "LLZK: Open-source infrastructure for secure ZK"
    url := "https://www.youtube.com/watch?v=8vgPLhtwNJU"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "March 2025"
    title := "Formally verifying zk(E)VMs with the Ethereum Foundation"
    url := "https://www.youtube.com/live/L_uz5rH50Sw?si=U_TtFXsHbMr5lpZ9"
    featured := true
  },
  {
    kind := .talk
    dateLabel := "March 2025"
    title := "Towards a verified Jolt zkVM"
    url := "https://www.youtube.com/live/O_bT89JK6_c?si=Sn1BiY__PWRAzoH9"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "March 2025"
    title := "Q1 2025: Cryptography Track update"
    url := "https://youtu.be/1bULK8iFVEo?si=vIQRUPyQDLalVs6c"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "March 2025"
    title := "Q1 2025: zkVM Track update"
    url := "https://youtu.be/C2NfJoihXyQ?si=PSjELgJCbwHtRgd6"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .talk
    dateLabel := "March 2025"
    title := "Q1 2025: EVM Track update"
    url := "https://youtu.be/op9LYW9083w?si=IQKjEMRxjA0ktFMK"
    trackTags := [.evm]
  },
  {
    kind := .article
    dateLabel := "January 2026"
    sourceLabel := "zkSecurity"
    title := "Lean4 Formalization of a Simplified Round-by-round Soundness Proof of FRI"
    url := "https://blog.zksecurity.xyz/posts/simple-rbr-fri/"
    trackTags := [.cryptography]
    featured := true
  },
  {
    kind := .article
    dateLabel := "January 2026"
    sourceLabel := "Formal Land"
    title := "Formal verification of the Keccak precompile from Plonky3"
    url := "https://formal.land/blog/2026/01/14/formal-verification-keccak-plonky3"
    trackTags := [.evm, .riscvZkvm]
    featured := true
  },
  {
    kind := .article
    dateLabel := "November 2025"
    sourceLabel := "zkSecurity"
    title := "Comparison of Formal Verification Frameworks for Arithmetic Circuits"
    url := "https://blog.zksecurity.xyz/posts/formal-verification-arithmetic-circuits/"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "November 2025"
    sourceLabel := "Nethermind"
    title := "Formally Verifying Zero-Knowledge Circuits: Introducing CertiPlonk"
    url := "https://www.nethermind.io/blog/formally-verifying-zero-knowledge-circuits-introducing-certiplonk"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "September 2025"
    sourceLabel := "Formal Land"
    title := "Verification of the completeness of an OpenVM chip"
    url := "https://formal.land/blog/2025/09/02/verification-completeness-open-vm-chip"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Veridise"
    title := "Announcing LLZK: A unified, open-source intermediate representation for zero-knowledge languages"
    url := "https://veridise.com/blog/zero-knowledge/announcing-llzk-a-unified-open-source-intermediate-representation-ir-for-zero-knowledge-languages"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Formal Land"
    title := "Pretty-printing of Rust ZK constraints"
    url := "https://formal.land/blog/2025/08/26/pretty-printing-rust-constraints"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Formal Land"
    title := "Formal verification of an OpenVM chip"
    url := "https://formal.land/blog/2025/08/13/verification-of-openvm-branch-eq"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Formal verification of LLZK circuits in Rocq"
    url := "https://formal.land/blog/2025/07/31/llzk-to-rocq-verification"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Semantics for LLZK in Rocq"
    url := "https://formal.land/blog/2025/07/30/llzk-to-rocq-semantics"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Beginning of a formal verification tool for LLZK"
    url := "https://formal.land/blog/2025/07/28/llzk-to-rocq-beginning"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "June 2025"
    sourceLabel := "Formal Land"
    title := "Beginning of translation of OpenVM to Rocq"
    url := "https://formal.land/blog/2025/06/15/beginning-of-openvm-to-rocq"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .article
    dateLabel := "March 2025"
    sourceLabel := "zkSecurity"
    title := "Introducing clean, a formal verification DSL for ZK circuits in Lean4"
    url := "https://blog.zksecurity.xyz/posts/clean"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .paper
    dateLabel := "OOPSLA 2025"
    title := "Certified Decision Procedures for Width-Independent Bitvector Predicates"
    url := "https://dl.acm.org/doi/10.1145/3763148"
    blurb? := some "Siddharth Bhat, Léo Stefanesco, Chris Hughes, Tobias Grosser."
    trackTags := [.evm]
    featured := true
  },
  {
    kind := .paper
    dateLabel := "OOPSLA 2025"
    title := "Interactive Bitvector Reasoning using Verified Bit-Blasting"
    url := "https://dl.acm.org/doi/10.1145/3763167"
    blurb? := some "Henrik Böving, Siddharth Bhat, Luisa Cicolini, Alex Keizer, Léon Frenot, Abdalrhman Mohamed, Léo Stefanesco, Harun Khan, Joshua Clune, Clark Barrett, Tobias Grosser."
    trackTags := [.evm]
  },
  {
    kind := .repo
    title := "Verified-zkEVM"
    url := "https://github.com/Verified-zkEVM"
    blurb? := some "GitHub organization"
    featured := true
  },
  {
    kind := .repo
    title := "Verified-zkEVM/verified-zkevm.org"
    url := "https://github.com/Verified-zkEVM/verified-zkevm.org"
  },
  {
    kind := .repo
    title := "Verified-zkEVM/ArkLib"
    url := "https://github.com/Verified-zkEVM/ArkLib"
    trackTags := [.cryptography]
    featured := true
  },
  {
    kind := .repo
    title := "Verified-zkEVM/CompPoly"
    url := "https://github.com/Verified-zkEVM/CompPoly"
    trackTags := [.evm]
  },
  {
    kind := .repo
    title := "Verified-zkEVM/iris-lean"
    url := "https://github.com/Verified-zkEVM/iris-lean"
    trackTags := [.evm]
  },
  {
    kind := .repo
    title := "Verified-zkEVM/VCV-io"
    url := "https://github.com/Verified-zkEVM/VCV-io"
    trackTags := [.cryptography]
  },
  {
    kind := .repo
    title := "Verified-zkEVM/clean"
    url := "https://github.com/Verified-zkEVM/clean"
    trackTags := [.riscvZkvm]
    featured := true
  },
  {
    kind := .repo
    title := "Verified-zkEVM/Overview"
    url := "https://github.com/Verified-zkEVM/Overview"
  },
  {
    kind := .repo
    title := "project-llzk/circom"
    url := "https://github.com/project-llzk/circom"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-lib"
    url := "https://github.com/project-llzk/llzk-lib"
    trackTags := [.riscvZkvm]
    featured := true
  },
  {
    kind := .repo
    title := "project-llzk/llzk-rs"
    url := "https://github.com/project-llzk/llzk-rs"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-nix-pkgs"
    url := "https://github.com/project-llzk/llzk-nix-pkgs"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-benchmarks"
    url := "https://github.com/project-llzk/llzk-benchmarks"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "Veridise/zirgen-to-llzk"
    url := "https://github.com/Veridise/zirgen-to-llzk"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "NethermindEth/CertiPlonk"
    url := "https://github.com/NethermindEth/CertiPlonk"
    trackTags := [.riscvZkvm]
  },
  {
    kind := .repo
    title := "formal-land/garden"
    url := "https://github.com/formal-land/garden"
    trackTags := [.riscvZkvm]
  }
]

def grantsForTrack (track : TrackKey) : Array GrantAward :=
  grants.filter (·.relatedTrack == some track)

def grantCaseStudyOfSlug? (slug : String) : Option GrantCaseStudy :=
  grantCaseStudies.find? (·.slug == slug)

def grantCaseStudyForAward? (grant : GrantAward) : Option GrantCaseStudy :=
  grantCaseStudies.find? (·.awardTitle == grant.title)

def grantCaseStudiesForTrack (track : TrackKey) : Array GrantCaseStudy :=
  grantCaseStudies.filter (·.relatedTrack == track)

def resourcesForTrack (track : TrackKey) : Array ResourceItem :=
  resources.filter fun r => r.trackTags.any (· == track)

def resourceItemsByKind (kind : ResourceKind) : Array ResourceItem :=
  resources.filter (·.kind == kind)

def featuredResources : Array ResourceItem :=
  resources.filter (·.featured) |>.take 6

end VerifiedZkEvmSite
