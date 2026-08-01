namespace VerifiedZkEvmSite

inductive TrackKey where
  | zkVM
  | evm
  | cryptography
  | general
deriving BEq, DecidableEq, Inhabited, Repr

def TrackKey.slug : TrackKey → String
  | .zkVM => "zkvm"
  | .evm => "evm"
  | .cryptography => "cryptography"
  | .general => "general"

def TrackKey.title : TrackKey → String
  | .zkVM => "zkVM"
  | .evm => "EVM"
  | .cryptography => "Cryptography"
  | .general => "General"

def TrackKey.path : TrackKey → List String
  | t => ["project", t.slug]

def trackKeyOfSlug? (slug : String) : Option TrackKey :=
  match slug with
  | "zkvm" => some .zkVM
  | "evm" => some .evm
  | "cryptography" => some .cryptography
  | "general" => some .general
  | _ => none

structure TrackInfo where
  key : TrackKey
  summary : String
  focus : String
  /-- Free-text executive summary of the track (status + outcomes), one entry per paragraph. Edit freely. -/
  overview : List String
  whatNext : List String
deriving Repr, Inhabited

def tracks : Array TrackInfo := #[
  {
    key := .zkVM
    summary := "Verification of zkVM arithmetizations against the official RISC-V Sail semantics."
    focus := "This track covers circuit semantics, extraction and comparison against machine specifications, and tooling that makes zkVM verification maintainable."
    overview := [
      "Current work is concentrated around extraction from machine specifications, verification of concrete circuit artifacts, and tooling that makes zkVM verification repeatable across implementations.",
      "The strongest outcomes so far are infrastructure-heavy: circuit DSLs, MLIR-based intermediate representations, fuzzing and bug-finding work, and early formal verification reports around concrete zkVM components."
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
    summary := "Verifying that the EVM guest program executed inside a zkVM correctly implements the EVM specification, with the assurance carried down to the RISC-V the prover actually runs."
    focus := "A zkVM proves the execution of a guest program, but there is no canonical guest. EVM implementations exist in Rust, Go, C++, Java, and other languages with very different formal-verification friendliness, and verifying any one of them at scale — while keeping a comparable level of assurance across them — is the central difficulty of this track. The work therefore targets EVM guests that can be verified down to the RISC-V they run as, currently centred on evm-asm: a verified macro assembler that builds the guest bottom-up from a machine-checked RV64 core so that no compiler sits in the trusted base."
    overview := [
      "The track's current centre of gravity is evm-asm, a Lean 4 verified macro assembler that implements EVM opcodes directly as RISC-V (RV64IM) subroutines with machine-checked correctness proofs. It builds the EVM guest from the bottom up: each opcode is implemented as RV64IM macro-assembly over 256-bit words held as four 64-bit limbs, and specified by a step-bounded Hoare triple in separation logic that the Lean kernel checks with no compiler in the trusted base and no unproved gaps or custom axioms. A parallel codegen path emits the verified programs as RISC-V ELFs and runs them on the Zisk emulator against the Python execution-specs reference.",
      "The earliest substantial work in this track was a Runtime Verification grant that took the opposite route: it symbolically verified the revm-interpreter crate of REVM, compiled to RISC-V via the RISC Zero and SP1 toolchains, using the K Framework and a K model of RISC-V semantics. It showed the compile-and-verify route is viable for arithmetic, memory, and logical opcodes and delivered reusable RISC-V semantics, an EVM opcode summarization system, and a K-to-Lean code generator — while also surfacing the limits of that route, which motivate the current evm-asm work."
    ]
    whatNext := [
      "a current picture of which EVM opcodes are proven, conditionally proven, or still open",
      "the path from verified opcodes to a complete, verified stateless block validator",
      "a comparison of the compile-and-verify and build-from-scratch routes on assurance, effort, and trusted-base size",
      "guidance on reaching parity of assurance across EVM guests written in different languages"
    ]
  },
  {
    key := .cryptography
    summary := "Verification of proof systems, security arguments, and cryptographic components used by zkVMs and zkEVMs."
    focus := "This track connects executable specifications, proof libraries, and formalized security reasoning for the cryptographic core of the stack."
    overview := [
      "Current work spans executable specifications for proof-system components, foundations for security arguments, and Lean-based tooling needed to make proof-system verification and cryptographic reasoning cumulative.",
      "This track already has visible outputs in the form of ArkLib, papers, talks, and specification-oriented grants, with ArkLib acting as a visible focal point. The main value now is consolidating those outputs into a clearer map of what has been formalized and what remains open."
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
  /-- One-line summary of what the grant produced. Populate per grant. -/
  output : Option String := none
deriving Repr

def grants : Array GrantAward := #[
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Verifying autoprecompiles"
    description := "Intended to support the verification of Powdr Labs' autoprecompiles."
    awardedTo := "Powdr Labs GmbH, Certora"
    period := some "Q4 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "AVAZAR: Automatic verification tools for zkVM arithmetization"
    description := "Intended to support work on automated verification tools for zkVM arithmetizations."
    awardedTo := "Universidad Complutense de Madrid (Albert Rubio)"
    period := some "Q4 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "ZKVM Agnostic Fuzzing"
    description := "Intended to support the development of fuzzing techniques applicable to any RISC-V zkVM."
    awardedTo := "zksecurity"
    period := some "Q3 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "zkBugs 2.0"
    description := "Intended to support an update of zkBugs."
    awardedTo := "zksecurity"
    period := some "Q3 2025"
    url := some "https://bugs.zksecurity.xyz"
    urlLabel := some "zkBugs"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Automated Verification of ZK Circuits"
    description := "Intended to support the development of techniques to automatically verify the consistency between witness generation and constraints."
    awardedTo := "Veridise"
    period := some "Q3 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "ZKarnage: Stress Testing ZK Systems Through Maximum Pain"
    description := "Intended to support work on prover killers."
    awardedTo := "Conner Swann"
    period := some "Q2 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Plonky3 in Rocq"
    description := "Intended to support an integration of Plonky3 with Rocq."
    awardedTo := "Formal Land"
    period := some "Q2 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Plonky3 to Lean"
    description := "Intended to support an integration of Plonky3 with Lean."
    awardedTo := "Nethermind"
    period := some "Q1 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Evaluating Verus for circuits and EVM precompiles"
    description := "Intended to support an evaluation of Verus as a tool to verify representative Rust code."
    awardedTo := "CertiK"
    period := some "Q1 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Better Rocq tactics for modular arithmetic & handling packed integers"
    description := "Intended to support the development of Rocq tactics for handling arithmetic modulo and packed integers."
    awardedTo := "CertiK"
    period := some "Q1 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "cLean"
    description := "Intended to support the development of a Lean DSL aimed at writing AIR circuits directly in Lean."
    awardedTo := "zkSecurity"
    period := some "Q4 2025"
    url := some "https://github.com/Verified-zkEVM/clean"
    urlLabel := some "Repository"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "LLZK"
    description := "Intended to support the development of LLZK, a family of MLIR dialects for circuits."
    awardedTo := "Veridise"
    period := some "Q4 2024, Q4 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
    title := "Lean backend for Sail"
    description := "Intended to support a Lean backend for Sail so that the official RISC-V Sail specification can be extracted to Lean."
    awardedTo := "University of Cambridge, Galois, Lindy Labs (first grant only)"
    period := some "Q1 2025, Q3 2025"
  },
  {
    group := "zkVM Track"
    relatedTrack := some .zkVM
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
  "zkVM Track",
  "EVM Track",
  "Cryptography Track",
  "General Tooling",
  "Events",
  "Community Resources and Education"
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
    dateLabel := "June 2026"
    title := "Raghav Malik - LLZK equivalence checker"
    url := "https://www.youtube.com/watch?v=RUNafYO6qqE"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "June 2026"
    title := "Ian Neal & Daniel Dominguez Alvarez - LLZK verification dialect"
    url := "https://www.youtube.com/watch?v=GGwsm5BiaBM"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "June 2026"
    title := "Ryan Kim - A Verifiable ZK Compiler Stack for Lean"
    url := "https://www.youtube.com/watch?v=A-z2EbiFRk8"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    title := "Ian Neal & Timothy Hoffman - LLZK 1.0"
    url := "https://www.youtube.com/watch?v=XOjWkWeG5QE"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    title := "Mathieu Fehr - Formal Semantics for MLIR dialects"
    url := "https://www.youtube.com/watch?v=6gspW3nNiCc"
    trackTags := [.general]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Quang Dao - Evolving the foundations of ArkLib"
    url := "https://www.youtube.com/watch?v=2lXCtxk-XxI"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Julian Sutherland - Reasoning about IOPPs"
    url := "https://www.youtube.com/watch?v=rnSo4dYYzLY"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Katerina Hristova - Mathematical foundations"
    url := "https://www.youtube.com/watch?v=2Ut6GLOCdJA"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Derek Sorensen - CompPoly"
    url := "https://www.youtube.com/watch?v=bqSiYJe6N-Q"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Devon Tuma - VCVio"
    url := "https://www.youtube.com/watch?v=ShcceSuJqxQ"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "James Parker - zkLean: A DSL for ZK statement verification"
    url := "https://www.youtube.com/watch?v=tR2w-xScTtw"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "ZKProof 8"
    title := "Gregor Mitscha-Baude - Clean: From verification of circuits to verification of zkVMs"
    url := "https://www.youtube.com/watch?v=Vcj6hjIXwNg"
    trackTags := [.zkVM]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "Lean FRO"
    title := "Bas Spitters - Software Verification in Lean"
    url := "https://www.youtube.com/watch?v=8K_kWJBQ20w"
    trackTags := [.cryptography]
  },
  {
    kind := .talk
    dateLabel := "May 2026"
    sourceLabel := "Lean FRO"
    title := "Quang Dao - Software Verification in Lean"
    url := "https://www.youtube.com/watch?v=WcOyDCqpN-w"
    trackTags := [.cryptography]
  },
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
    dateLabel := "April 2026"
    title := "Luisa Cicolini - Certified Instruction Selection For LLVM IR Through Bitblasting"
    url := "https://www.youtube.com/watch?v=QJHtkyBSxaQ"
    trackTags := [.general]
  },
  {
    kind := .talk
    dateLabel := "April 2026"
    title := "Petar Maksimović - OpenVM and Pico in Lean"
    url := "https://www.youtube.com/watch?v=HVqf8lARdF0"
    trackTags := [.zkVM]
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
    trackTags := [.zkVM]
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
    trackTags := [.zkVM]
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
    title := "Elizaveta Pertseva - Automated Lean Proofs for Every Type"
    url := "https://www.youtube.com/watch?v=qyo3INdLAJk"
    trackTags := [.zkVM]
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
    trackTags := [.evm, .zkVM]
  },
  {
    kind := .talk
    dateLabel := "September 2025"
    title := "LLZK: Open-source infrastructure for secure ZK"
    url := "https://www.youtube.com/watch?v=8vgPLhtwNJU"
    trackTags := [.zkVM]
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
    trackTags := [.zkVM]
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
    trackTags := [.zkVM]
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
    trackTags := [.evm, .zkVM]
    featured := true
  },
  {
    kind := .article
    dateLabel := "November 2025"
    sourceLabel := "zkSecurity"
    title := "Comparison of Formal Verification Frameworks for Arithmetic Circuits"
    url := "https://blog.zksecurity.xyz/posts/formal-verification-arithmetic-circuits/"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "November 2025"
    sourceLabel := "Nethermind"
    title := "Formally Verifying Zero-Knowledge Circuits: Introducing CertiPlonk"
    url := "https://www.nethermind.io/blog/formally-verifying-zero-knowledge-circuits-introducing-certiplonk"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "September 2025"
    sourceLabel := "Formal Land"
    title := "Verification of the completeness of an OpenVM chip"
    url := "https://formal.land/blog/2025/09/02/verification-completeness-open-vm-chip"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Veridise"
    title := "Announcing LLZK: A unified, open-source intermediate representation for zero-knowledge languages"
    url := "https://veridise.com/blog/zero-knowledge/announcing-llzk-a-unified-open-source-intermediate-representation-ir-for-zero-knowledge-languages"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Formal Land"
    title := "Pretty-printing of Rust ZK constraints"
    url := "https://formal.land/blog/2025/08/26/pretty-printing-rust-constraints"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "August 2025"
    sourceLabel := "Formal Land"
    title := "Formal verification of an OpenVM chip"
    url := "https://formal.land/blog/2025/08/13/verification-of-openvm-branch-eq"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Formal verification of LLZK circuits in Rocq"
    url := "https://formal.land/blog/2025/07/31/llzk-to-rocq-verification"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Semantics for LLZK in Rocq"
    url := "https://formal.land/blog/2025/07/30/llzk-to-rocq-semantics"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "July 2025"
    sourceLabel := "Formal Land"
    title := "Beginning of a formal verification tool for LLZK"
    url := "https://formal.land/blog/2025/07/28/llzk-to-rocq-beginning"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "June 2025"
    sourceLabel := "Formal Land"
    title := "Beginning of translation of OpenVM to Rocq"
    url := "https://formal.land/blog/2025/06/15/beginning-of-openvm-to-rocq"
    trackTags := [.zkVM]
  },
  {
    kind := .article
    dateLabel := "March 2025"
    sourceLabel := "zkSecurity"
    title := "Introducing clean, a formal verification DSL for ZK circuits in Lean4"
    url := "https://blog.zksecurity.xyz/posts/clean"
    trackTags := [.zkVM]
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
    title := "Verified-zkEVM/evm-asm"
    url := "https://github.com/Verified-zkEVM/evm-asm"
    blurb? := some "Verified macro assembler building the EVM guest bottom-up from a machine-checked RV64 core (experimental prototype)"
    trackTags := [.evm]
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
    trackTags := [.zkVM]
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
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-lib"
    url := "https://github.com/project-llzk/llzk-lib"
    trackTags := [.zkVM]
    featured := true
  },
  {
    kind := .repo
    title := "project-llzk/llzk-rs"
    url := "https://github.com/project-llzk/llzk-rs"
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-nix-pkgs"
    url := "https://github.com/project-llzk/llzk-nix-pkgs"
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "project-llzk/llzk-benchmarks"
    url := "https://github.com/project-llzk/llzk-benchmarks"
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "Veridise/zirgen-to-llzk"
    url := "https://github.com/Veridise/zirgen-to-llzk"
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "NethermindEth/CertiPlonk"
    url := "https://github.com/NethermindEth/CertiPlonk"
    trackTags := [.zkVM]
  },
  {
    kind := .repo
    title := "formal-land/garden"
    url := "https://github.com/formal-land/garden"
    trackTags := [.zkVM]
  }
]

def grantsForTrack (track : TrackKey) : Array GrantAward :=
  grants.filter (·.relatedTrack == some track)

def resourcesForTrack (track : TrackKey) : Array ResourceItem :=
  resources.filter fun r => r.trackTags.any (· == track)

def resourceItemsByKind (kind : ResourceKind) : Array ResourceItem :=
  resources.filter (·.kind == kind)

def featuredResources : Array ResourceItem :=
  resources.filter (·.featured) |>.take 6

end VerifiedZkEvmSite
