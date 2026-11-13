# Finch sensitivity and diagnostic review

Completed 11 November 2026 using scripts/05_robustness.R. All 13 omission fits completed; none was discarded. Detailed outputs and diagnostic PDF are in results/robustness-2026-11-11/.

| Check | Observed result | Interpretation |
|---|---|---|
| Full BM/REML slope | 3.038481 | Association on distributed scale |
| All 13 leave-one-out slopes | 2.811024 to 3.142004 | Positive direction survives every single omission |
| Leave-one-out 95% intervals | All lower bounds above zero | Conditional on each retained tree and model |
| Largest slope change | psittacula omitted, absolute change 0.227457 | No single omission reverses the slope |
| Fixed lambda zero reference | slope 3.082400 | Similar direction under independence; no model selection performed |
| K randomization P after omission | 0.012012 to 0.212212 | Signal threshold conclusion is taxon-sensitive |
| Lambda test P after omission | 0.050899 to 1.000000 | No stable rejection at 0.05 across deletion datasets |
| Normalized residual Shapiro check | W 0.901709; P 0.141149 | Low-power descriptive check, not proof of normality |

The four-panel diagnostic PDF includes residual versus fitted, a Q–Q plot, every omission interval and K-test sensitivity. Conditional GLS leverage is saved separately. Whitened-coordinate leverage is an ordered transformed-design diagnostic and must not be interpreted as ordinary species influence; deletion refits provide the species-specific sensitivity assessment.

Omitting fusca is one of the 13 reported diagnostics; it is not a resolution of the cross-distribution naming discrepancy. A robust numerical slope does not establish correct species mapping or the original physical scale. No biological causal or adaptive conclusion is supported by these checks alone.
