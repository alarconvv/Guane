# Guane project status and December draft plan

Status date: 27 October 2026. Target: a complete first manuscript draft on **31 December 2026**, ready for coauthor review. This is a drafting deadline, not a promise of submission or biological validation.

The author selected the **original Guane application for a Methods in Ecology and Evolution paper** on 27 October 2026. Revise the existing Applications draft around the multilingual R/Shiny application, its reproducible workflows and qualified empirical examples. Connect every claim to evidence from this implementation. Guaneverse remains separate development.

## Where the work lives

| Location | Role | How to use it |
|---|---|---|
| This repository, `Guane/` | Original multilingual R/Shiny application; current HEAD `e571dff`, 26 September | Preserve as the original app. Its tests and async architecture belong to this implementation. |
| [Guane manuscript](../../Guane-manuscript/README.md) | Existing Applications draft, empirical datasets, scripts and results | Start writing from the existing draft; do not start another manuscript from scratch. |
| [Guaneverse](../../Guane.verse/README.md) | Later experimental ecosystem: nine packages, 56 executable contracts across eight inventory families | Separate development, outside this manuscript scope. Its method counts and validation do not establish evidence for the original app. |
| [Earlier development workspace](../../Guane-codex-full/README.md) | Historical milestone records, checks, scientific limitations and implementation history | Consult for provenance and older decisions; do not treat historical acceptance as current validation. |
| `Guane-Oldversions/` | Older versions | Retain as history; not reviewed as a source of current results in this inventory. |

These are separate directories, not interchangeable releases. The sibling manuscript and Guaneverse folders are not Git repositories at their current locations. Do not merge their files into this app just to simplify navigation. Select and record a canonical source snapshot before final validation.

## Current position

| Area | Evidence available | Current conclusion |
|---|---|---|
| Original app | Source, examples, unit/integration/functional/security suites; September evaluation | Substantial implementation. September browser validation was blocked, and its old test record does not validate the current HEAD. |
| Existing manuscript | [Editable manuscript](../../Guane-manuscript/Guane_MEE_manuscript.md), LaTeX counterpart, tables, bibliography and author notes | A substantial draft exists. It describes the September original app, not the expanded Guaneverse ecosystem. |
| Guaneverse engineering | [18 October gate summary](../../Guane.verse/artifacts/ou-asr-gates.txt), [current checklist](../../Guane.verse/docs/IMPLEMENTATION_CHECKLIST.md) | Recorded PASS: nine clean package checks, 56 API/UI/export replays, functional, scoped security and automated accessibility checks. On 27 October all 186 files in its saved source manifest matched their SHA-256 hashes. This is source verification, not a new test run. |
| Method coverage | [Method reference](../../Guane.verse/docs/METHOD_REFERENCE.md), [inventory](../../Guane.verse/catalog/inventory.csv), [remaining methods](../../Guane.verse/docs/UNIMPLEMENTED_METHODS.md) | 98 workbook rows; 56 contracts cover 44 rows plus three mapping extensions. The remaining 54 rows are 34 deferred and 20 blocked. Contracts and workbook rows count different things. |
| Butterfly example | Six model fits, reconstruction, 100 conditional histories, fixed-Q agreement and saved-result export replay | Suitable as a qualified workflow example. Optimization sensitivity prevents definitive model-support claims. |
| Frog example in original manuscript | Full 1,579-tip bounded HiSSE/CID-2/CID-4 attempts and exports | Completed diagnostic demonstration; native fits did not satisfy convergence/verification requirements. No biological model ranking is supported. |
| Guaneverse hidden-model validation | Timing, support profiles, pilots, eligibility study and confirmation assessment | Extensive engineering/numerical evidence; biological sign-off remains withheld. |
| Researcher interpretation | Explicit hold in current checklist | Remains on hold until end of development and a decision to release the hold. Developer checks do not establish researcher comprehension. |
| Release and authorship | [Author notes](../../Guane-manuscript/AUTHOR_NOTES.md) | Author information, reviewed claims, reproducible environment and release/archive decisions remain open. |

## Confirmed paper scope

**Decision recorded 27 October 2026:** original Guane paper for **Methods in Ecology and Evolution**, using the existing Applications manuscript as the starting point. Article category and submission instructions should be checked during submission preparation.

Present the original multilingual Shiny application as software infrastructure connecting explicit data preparation, established comparative methods, diagnostics and exported R workflows. Describe its modular interface and background execution using evidence from this repository. The existing evaluation identifies 17 analysis cards across four families; confirm these against the frozen source before finalizing the paper.

Retain the butterfly reconstruction and frog diagnostic demonstration with their optimization limitations. Saved-result replay and inference refitting must be described separately. The paper does not require successful hidden-model recovery or new biological model-support claims.

Guaneverse's nine packages, 56 contracts, added methods and October engineering gates are outside this paper's implementation and validation claims. Its CID2/MiSSE studies remain in the broader project evidence register as separate research; they are not required results for this draft.

By 6 November, finalize the paper question, central claims, reviewer assignments and the original-app source snapshot to evaluate. The implementation and target journal are already decided.

## Milestones to 31 December 2026

All dates use America/New_York. Roles below are proposed responsibilities; actual people have not been assigned.

| Period | Deliverable | Completion condition | Proposed lead |
|---|---|---|---|
| 27 October–6 November | Scope and evidence freeze | Original Guane and target journal confirmed; finalize paper question and core claims; name reviewers; save original-app source/version hashes | Corresponding author with software lead |
| 7–20 November | Reproducibility and validation package | Repair original-app validation blockers; record dependencies; run relevant gates; separate refits from saved-result replay; reconcile example scripts and paths | Software and analysis leads |
| 21 November–4 December | Results and figures freeze | Check numerical tables against saved outputs; finalize architecture/workflow figure, qualified empirical figures and limitations; classify every unfinished study | Analysis lead and scientific reviewer |
| 5–11 December | Complete integrated manuscript | Abstract, introduction, methods, results, discussion, references and supplement outline all present; each central claim linked to evidence | Manuscript lead |
| 12–18 December | Coauthor review round | Scientific reviewer checks assumptions and interpretations; software reviewer checks reproducibility; author details collected | Assigned coauthors |
| 19–24 December | Revised first draft candidate | Resolve critical comments; synchronize Markdown and LaTeX; check figures, citations, tables and availability text | Manuscript lead |
| 25–30 December | Buffer and final consistency check | Complete a representative clean replay; label remaining limitations; package draft and supplement index | Manuscript and software leads |
| 31 December | Deliver first draft | Dated manuscript, figures/tables, supplement inventory, evidence index and explicit remaining-work list ready for coauthors | Corresponding author |

The draft depends on validating the original app and documenting its empirical workflows. Guaneverse confirmation studies and inventory expansion remain separate work. Any new scientific study needs its own prospective scope; the existing qualified examples provide the manuscript baseline.

## Weekly working routine

- Start each week with the [pending work register](PENDING_WORK.md). Assign one named owner and a concrete output to each active item; focus on at most three priorities.
- Keep writing alongside validation. Update the methods and limitations while checks run rather than waiting for all analyses to finish.
- At the weekly review, record what completed, the output path, the source/dependency versions, the exact claim supported and the next action. A RUNNING marker or script file alone is not a result.
- Preserve frozen studies and historical logs. Create a new run directory for any future authorized experiment; retain errors, ineligible draws, stopped jobs and unknown outcomes.
- End each week by updating the manuscript and this status summary. Use the [evidence register](EVIDENCE_REGISTER.md) to keep old proposals separate from terminal assessments.

## What the December draft must contain

- One clearly identified software implementation and version, with architecture and method counts matching that version.
- A complete scientific narrative and explicit contribution as software infrastructure.
- Empirical examples with provenance, declared assumptions, settings, diagnostics and qualified conclusions.
- Tables and figures traceable to scripts and saved results; exported replay distinguished from recomputing inference.
- A tested environment description, evidence index and reproducibility instructions that work from the stated directory.
- Limitations covering optimization, identification, conditional uncertainty and unvalidated biological or usability claims.
- Author review items and availability statements accurately labeled where decisions remain pending.

## Inventory boundary

This status review inspected local source, documentation, tables and logs. It verified the Guaneverse source manifest but did not rerun scientific fits or full test suites. The historical external study path `/Volumes/dataMac2026/Guaneverse` was unavailable during this review, so external raw records would need an access/integrity check if used in future work. They are outside the confirmed original-Guane paper scope. Website content and current journal instructions were not assessed; confirm submission requirements when preparing submission.
