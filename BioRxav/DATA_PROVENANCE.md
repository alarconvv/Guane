# Dataset provenance and reuse

## Selected small dataset

Use `geospiza` distributed with **geiger 2.0.12**, the Darwin's finch comparative dataset. Public source: [CRAN geiger](https://cran.r-project.org/package=geiger), [versioned package archive](https://cran.r-project.org/src/contrib/geiger_2.0.12.tar.gz), and [maintainer repository](https://github.com/mwpennell/geiger-v2). The installed package supplied the object used here; its DESCRIPTION and help text are preserved in evidence/.

The distribution has a 14-tip empirical phylogeny and a 13-row, five-column continuous morphological matrix. The package attributes this dataset to **Dolph Schluter**. The [ouch maintainer documentation](https://kingaa.github.io/manuals/ouch/html/geospiza.html) independently describes it as morphological measurements of Darwin's finches with a phylogeny obtained from geiger. This is a historical empirical teaching dataset, not a simulation or a new field study. Do not describe all its taxa as belonging to the modern genus Geospiza: several distributed labels represent other finch lineages.

The immediate, versioned computational provenance is clear. The current geiger help has only “Schluter D” for the historical source and does not establish a primary collection protocol, per-species sample sizes or the exact original tree publication. Those deeper provenance details remain a publication task. Do not assign the distributed tree to Sato et al. or another study without confirmation.

## Reuse terms

CRAN and the installed DESCRIPTION declare **GPL (>= 2)** for geiger. The inspected help does not declare a separate dataset license. This project preserves the data under those package distribution terms, including the bundled GPL-2 text and attribution; it does not relicense them as CC0 or CC BY. GPL permits reuse and redistribution subject to its conditions and is not a permissive license in the MIT/CC0 sense. If a distinct public-domain data license is essential, resolve the CC0 alternative below before finalizing the paper. Manuscript licensing and redistributed software/data licensing must be recorded separately.

## Exact preparation

The source RDS, unpruned Newick and distributed CSV are retained in data/raw/. `scripts/01_prepare.R` extracts the dataset from a fixed package version, checks the expected mismatch, prunes only **olivacea**, and orders rows exactly by the retained tree tips. The missing trait row is not imputed. All 13 available trait rows and all five columns are retained. There is no significance-based selection of taxa. `data/exclusions.csv` records the one exclusion. The final tree is rooted, bifurcating, ultrametric and has positive branch lengths; these are checked rather than enforced by modifying branch lengths.

## Trait dictionary

| Column | Meaning | Use |
|---|---|---|
| taxon | Original distributed identifier | Exact case-sensitive tree matching |
| wingL | Wing length measurement on distributed scale | PGLS predictor |
| tarsusL | Tarsus length measurement on distributed scale | Retained, not analyzed |
| culmenL | Culmen length measurement on distributed scale | Retained, not analyzed |
| beakD | Beak depth measurement on distributed scale | Signal trait and PGLS response |
| gonysW | Gonys width measurement on distributed scale | Retained, not analyzed |

Retain the supplied scale without another log transformation. These data are commonly used as logged morphology, but the inspected current geiger help is too generic to establish each variable's unit, aggregation and transform. Do not label axes as millimetres or interpret the slope as an elasticity until those details are verified. Branch-length units likewise remain those of the distributed tree, not asserted millions of years.

## CC0 alternative examined

[Revell, Mahler, Reynolds and Slater 2015, Dryad DOI 10.5061/dryad.1st98](https://doi.org/10.5061/dryad.1st98), associated article [10.1111/evo.12628](https://doi.org/10.1111/evo.12628), provides real Anolis morphology and a tree. Dryad API metadata explicitly declares [CC0-1.0](https://spdx.org/licenses/CC0-1.0.html). Dataset/version metadata are saved in evidence/. Tree: 3,799 bytes, MD5 `51ec645b3efcb8efaee44ed930167b27`; traits: 27,757 bytes, MD5 `c3b5a6ce88202dbf12a733d4ead1411c`. Metadata endpoints: `/api/v2/versions/6178/files`, `/api/v2/datasets/doi%3A10.5061%2Fdryad.1st98` on datadryad.org.

Public file links returned 403; API download links required a bearer token; the old author teaching mirror returned a missing-file page. None of these responses were accepted as data. The archive was not used for figures or estimates. For a strict CC0 alternative, obtain the two files from the Dryad landing page, verify both MD5 checksums and inspect trait definitions before writing preparation code. The complete tree is approximately 100 tips, larger than the selected finch example; any smaller geographical subset must be declared before examining results. Do not substitute an unverified anole table from older GUANE examples.

## Provenance audit on 11 November 2026

**Outcome: immediate distribution confirmed; original collection source, exact units/transform and tree calibration not confirmed.** Current geiger documentation, geiger 1.0-91 documentation and phylobase documentation credit Dolph Schluter (phylobase specifies via Luke Harmon). None identifies a collection publication or measurement protocol. The [ouch maintainers explicitly report that no additional details were supplied](https://kingaa.github.io/manuals/ouch/html/geospiza.html). The modern geiger help's general statement about natural-log body sizes is not a variable-specific record for this five-column morphology matrix. Plausible exponentiated values are not documentary proof of natural logs or millimetres.

The [BEAST project finch example](https://beast.community/continuous_traits) and [its source trait file](https://github.com/beast-dev/beast-mcmc/blob/master/examples/ContinuousTraits/DarwinsFinchesTraits.txt) contain exactly the same 65 numerical values, verified by scripts/06_provenance_audit.R. However, the five values labelled **fusca** in geiger match **Certhidea olivacea** in the BEAST file. Other identifiers include genus-level shorthand in geiger. This shows a cross-distribution naming discrepancy; it does not prove which label or tree assignment is correct. Both warbler-finch lineages are present in the distributed geiger tree. No labels have been changed and no traits have been reassigned.

Saved evidence: provenance-review/geiger-data.Rd, geiger-1.0-91-geospiza.Rd, phylobase-geospiza.Rd, BEAST-finches-traits.txt and cross-distribution-label-audit.csv under evidence/. No primary collection paper, precise unit, log base, aggregation rule, sample size, exact tree origin/calibration or separate dataset license has been established. Package GPL licensing alone does not establish the rights chain for the original observations. Confirm these points with the data originator/package maintainer before making biological claims or publicly depositing a dataset derivative. A ready-to-send inquiry is in submission/PROVENANCE_INQUIRY.txt; it has not been sent.

Until resolved, retain this as a **historical software demonstration on the distributed scale**. The supplied-table calculation is reproducible; species-level biological interpretation remains conditional on resolving the mapping. Removing fusca is included as a diagnostic sensitivity, not accepted as a taxonomic correction. This issue is a release condition for the December 8 target.
