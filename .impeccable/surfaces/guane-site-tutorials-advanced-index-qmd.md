---
version: 1
slug: "guane-site-tutorials-advanced-index-qmd"
primary_target: "guane-site/tutorials/advanced/index.qmd"
related_targets: ["guane-site/index.qmd"]
---

# Surface: Guane docs — Advanced tutorials

Scope: guane-site/tutorials/advanced/ (overview + one page per family: phylo-traits, asr, diversification, sse), plus a craft raise of the whole docs site inside its established world.
Mode: Read.
Audience: researchers who finished the beginner tutorials and now run their own data (confirmed 2026-09-26).
Job: find the advanced control they need, understand what it changes, use it on the bundled example, and judge the result in Diagnostics before interpreting.
Content source: R/ui_mod_*.R (labels, defaults), R/core_mod_*.R (behavior), guane-site/reference/input-formats.qmd, guane-site/reference/limitations.qmd.
Constraints: only real UI labels; synthetic example is not evidence; WCAG 2.2 AA; Quarto built-ins only.
Unresolved: Spanish/Portuguese docs; 2x screenshot recapture of the beginner shots.

## Direction contract
THESIS: Advanced controls taught as judgment, not a parameter dump. Every control answers: what it changes, its default, when to change it, what to check afterwards. Refuses the category default of an exhaustive argument table.
OWN-WORLD: Inherited Guane docs world: teal #0d5368 navbar, forest-green hero gradient, bark eyebrows, `.ui` interface labels, `.guane-meta`, `.guane-steps`, framed `.guane-shot` screenshots. One new component in the same corner and line language: a control card (label chip, where it lives, default, change it when, check after).
STORY: The researcher picks a family, scans its control cards, follows one worked advanced recipe on the example, reads Diagnostics with the page's help, and leaves knowing when a result is defensible.
FIRST VIEWPORT: Overview page: title and one-sentence purpose; a meta box (prerequisites: beginner tutorial for that family); a 2x2 family grid reusing the module cards, each naming its 3–4 flagship advanced controls.
FORM: Extension of an established surface (new-work §3, extend); no concept roll; seed key: none (extension).
FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
