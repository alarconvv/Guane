# GUANE mammal preprint package

**Current mammal-based package for author review. Target: 8 December 2026. Nothing has been submitted, published, uploaded to an archive or sent to others.** Author details and final posting approval will be supplied later by the author.

Start with **manuscript/MANUSCRIPT_REVIEW.pdf**, then **GUI_EXECUTION_REPORT.md**. This package replaces the finch example in the current draft. The older finch folders and ZIP remain historical records; do not mix their screenshots or numerical results into this mammal paper.

## Folder map

| Folder | Contents |
|---|---|
| manuscript | Editable Markdown manuscript and review PDF with two embedded main figures |
| figures | Both main figures in PDF and PNG |
| gui | Original GUI CSV exports, downloaded R scripts, available original graph PDF, screenshots, captured visible text and export-attempt log |
| terminal | Full-precision recomputation, clean-script replays, logs, session versions, fit objects and verification checks |
| data | Matched 49-species Newick tree, CSV with raw kg/km² and separate natural-log columns, prepared RDS |
| reproduce | Numbered scripts and run_all.R to regenerate calculations, sensitivity and figures |
| source | Frozen original GUANE computation files with GPL notice |
| evidence | Package documentation, original-table comparison and version metadata |
| supplement | All 49 omission fits, covariance sensitivity and full historical tree |

## Reproduce the exercise

Install R and the documented packages once if needed: phytools 2.5-2 (packageVersion 2.5.2), ape and nlme. The tested R version is 4.6.0; terminal/sessionInfo.txt lists exact loaded versions. The preparation script stops if phytools is a different version rather than silently using changed example data.

Open a terminal in **this submission-mammals directory** and run:

```sh
Rscript --vanilla reproduce/run_all.R
```

This runs preparation, frozen GUANE computations, displayed-script and downloaded-script refits in separate clean R sessions, all 49 omission fits, figures and numerical comparisons. It overwrites only derived data/terminal/figure/supplement files inside this exercise. It preserves the GUI evidence and manuscript. No full GUANE installation or network download is required for the terminal replay once the declared packages are installed. If packages must be installed, use their official CRAN distributions; this script does not install anything automatically.

To repeat the GUI independently, follow reproduce/GUI_STEPS.md. The live application itself is maintained in the separate original GUANE repository; the frozen source files here reproduce the tested calculations, not the full web application.

## Review and submission files

- manuscript/MANUSCRIPT_REVIEW.pdf is the assembled paper for checking, with the current mammal data and figures.
- GUI_OUTPUTS_REVIEW.pdf wraps the GUI evidence and explains which files are original exports and which are terminal replays.
- METADATA.tsv holds author-editable submission fields; nothing is invented for missing author details.
- DECEMBER_8_SCHEDULE.md is the written schedule only. No calendar event or reminder was created.
- SHA256SUMS.txt records every file in the frozen package except itself.

Before any actual posting, complete author information, final coauthor/scientific review, manuscript-license selection, data/code attribution review and an authorized persistent archive. A public DOI and all-author approval have not been supplied. Check the current bioRxiv portal requirements at the time of submission. This is a prepared local package, not an assertion of acceptance or a completed deposit.
