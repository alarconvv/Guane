# Custom input formats

These are the formats accepted by the current controls. Enter them in the corresponding **text box**, not in the main trait CSV upload. Commas are delimiters; a row ends with a new line. Preserve exact column names and state spelling. Names shown in examples are illustrative: use the states and node IDs displayed for your data. When a card offers **Fill parameter table**, **Fill custom matrix**, or **Fill custom constraints**, click it first and edit the generated template. This is especially important when the number or order of parameters depends on your tree or chosen model. Leave an optional table blank to use the card's defaults.

## Uploaded data files

**Tree:** one `.nwk`/`.tre` Newick or `.nex`/`.nexus` Nexus tree, with unique tip labels. A minimal Newick example is `(Sp01:1,(Sp02:0.5,Sp03:0.5):0.5);`. Method-specific requirements (rooting, positive branch lengths, ultrametricity) are checked when you run an analysis. LTT may instead accept multiple Newick tree files in its own upload control.

**Trait CSV:** one header row, one taxon per row, and a unique taxon identifier column. A small format example is:

```csv
species,body_mass,habitat_binary,resource_use_polymorphic
Sp01,12.5,forest,fruit+seed
Sp02,18.2,open,seed
Sp03,14.7,forest,fruit
```

Tip labels must match the taxon identifiers exactly; extra whitespace and different capitalization are different names. Continuous columns need numeric values. Count PGLM responses need nonnegative integers. Grouped-binomial PGLM needs integer successes and trials, with `0 <= successes <= trials` for each taxon. A polymorphic cell joins *coexisting* constituent states with `+`, e.g. `fruit+seed`; it does not mean uncertainty or a missing value. The bundled [19-row trait CSV](../inst/example/guane-example-traits.csv) and [20-tip tree](../inst/example/guane-example-tree.nwk) deliberately have one unmatched tip. Inspect Checking data and explicitly choose **Use matched taxa** before a trait analysis.

## Ancestral state reconstruction

**Custom Mk transition index matrix (discrete or polymorphic):** paste a square comma-separated matrix **without row/column headers**. Row = source state, column = destination state, both in the **displayed state order**. The diagonal and forbidden transitions are `0`. Repeated positive integers tie rates; distinct consecutive integers `1,2,...` estimate separate rates. For two displayed states, this allows different forward/backward rates:

```text
0,1
2,0
```

For polymorphic traits, the number of rows equals the number of **allowed composite states**, which is often greater than the number of constituent states. Use **Fill custom matrix** and adjust the generated indices. Do not paste trait names into the matrix. A model's graph of allowed transitions and connectivity constraints still apply.

**Root-state weights:** one `state,weight` row per allowed state, **no header**. Nonnegative finite weights with a positive total are normalized internally. For example, if the displayed states are `forest` and `open`:

```text
forest,0.7
open,0.3
```

**Fixed Q rate matrix:** a named numeric square CSV. The first cell of the header row can be empty; row and column names must each contain every allowed state exactly once. Off-diagonal entries are nonnegative transition rates; each diagonal is minus its row's off-diagonal sum. Rates must respect forbidden and shared transitions in the selected model. Example for `forest`, `open`:

```csv
,forest,open
forest,-0.2,0.2
open,0.1,-0.1
```

**Custom starting rates:** one numeric value, or one value per positive transition index, ordered `1,2,...`; separate values with commas or spaces. Example: `0.1, 0.2`. Each value must lie within the selected rate bounds. A fixed Q is not optimized, so starting rates and fitted-model comparison do not apply to it.

**Discrete/polymorphic Bayesian rate-prior table:** exact CSV headers `Parameter,Shape,Rate,ProposalVariance`; one row per fitted rate index (`q1`, `q2`, etc.). All numeric values must be positive. `Shape` and `Rate` specify each gamma prior; `ProposalVariance` tunes the MCMC proposal. Click **Fill rate-prior table** to get the correct number of rows. A two-rate format example is:

```csv
Parameter,Shape,Rate,ProposalVariance
q1,1,1,0.1
q2,1,1,0.1
```

**Continuous Bayesian BM parameter table:** exact headers `Parameter,Start,PriorMean,PriorVariance,ProposalVariance`. Include one `sig2` row followed by **every internal node** in the tree, using the node IDs in the filled template. The `sig2` prior uses its positive `PriorMean` as the exponential-prior mean and must have `NA` in `PriorVariance`; node rows have normal priors with positive variance. Start and proposal variances must be valid; `sig2` Start must be positive. Use **Fill Bayesian parameter table** rather than guessing node IDs:

```csv
Parameter,Start,PriorMean,PriorVariance,ProposalVariance
sig2,0.5,1000,NA,0.01
21,12.0,0,1000,0.01
```

The example above shows the format only; a real 20-tip tree requires a row for every internal node.

**Ordered polymorphic constituent order:** one constituent state per line, each exactly once, in the desired order. Specify the maximum polymorphism size separately. For example:

```text
fruit
seed
insect
```

Only contiguous combinations in that order are permitted. The bundled polymorphic example contains all three pairwise combinations, so **no linear order of its three constituents can make every pair contiguous**. Use it for unordered models. An ordered analysis needs a suitable custom dataset or an explicitly justified recoding; Guane does not silently change observed states.

**Custom state colors:** no-header `state,#RRGGBB`, with every allowed state exactly once. Example:

```text
forest,#2277AA
open,#CC7733
```

**Continuous trait gradient:** two to eight six-digit hex colors separated by commas or spaces, e.g. `#E4F1CF, #54A37A, #0D5368`. These change graphs, not estimates.

## Diversification

**Clade-specific sampling:** exact headers `Node,Sampling`; one row for each selected crown node, using the numeric IDs shown by **Preview selected clades**. Fractions must be in `(0,1]`:

```csv
Node,Sampling
24,1
31,0.8
```

These node IDs are illustrative; use the IDs for your tree. Selected crown clades must be eligible and non-overlapping.

**Joint clade-dependent regional sampling:** exact headers `Region,Sampling`. Include background region `0` and each chosen shift-node ID once, with fractions in `(0,1]`. Get the actual region IDs from **Preview joint regions**:

```csv
Region,Sampling
0,1
24,0.8
```

**Joint custom rate constraints:** exact headers `Region,Lambda,Mu`, one row per displayed region. In each rate cell, a nonnegative number fixes that rate or a name estimates it. Fixed `Lambda` must be positive. Reuse a name within the same rate type to tie regions; never reuse one name between `Lambda` and `Mu`. For example:

```csv
Region,Lambda,Mu
0,lambda_shared,0
24,lambda_shift,0
```

**Joint free-parameter controls:** exact headers `Parameter,Start,Lower,Upper`, one row per free name you want to override. Starts must be strictly inside bounds; free speciation lower bounds must be positive. For the preceding custom constraints:

```csv
Parameter,Start,Lower,Upper
lambda_shared,0.5,0.001,10
lambda_shift,0.7,0.001,10
```

Other diversity-dependent advanced fields use a **comma-separated numeric vector** in the displayed parameter order, rather than a CSV table. The number/order of start values depends on the selected DDD model. Use the control's displayed parameter labels and its default values as the template; keep all tolerance values positive.

## SSE models

**BiSSE, MuSSE, QuaSSE rate-parameter tables:** the shared exact headers are `Parameter,Group,Fixed,Start,Lower,Upper`. `Parameter` must match the generated template for that model. `Group` ties free parameters with the same name; `Fixed` sets a numeric value instead of estimating it. Keep a valid `Group` name in every row; leave `Fixed` blank for a free rate. For non-Custom presets, Guane replaces Group/Fixed with that preset’s constraints. The columns `Start`, `Lower`, and `Upper` control optimization. The available rows vary with the card, number of MuSSE states, and QuaSSE rate functions, so use **Fill parameter table** after choosing the model/functions and edit the result. A BiSSE format example is:

```csv
Parameter,Group,Fixed,Start,Lower,Upper
lambda0,lambda,,0.5,0,100
lambda1,lambda,,0.5,0,100
mu0,mu,0,0,0,100
mu1,mu,0,0,0,100
q01,q01,0.2,0.2,0,100
q10,q10,0.2,0.2,0,100
```

The `Group`/`Fixed` columns are used only by a **Custom** model where the card exposes one. A fixed rate must fit its bounds; check the effective constraints in Diagnostics. For QuaSSE, after changing Constant/Exponential/Sigmoid rate functions, fill the table again to refresh parameter names. Signed slopes, midpoints, and drift have different admissible ranges from positive diffusion/rate parameters.

**MuSSE observed-state table:** exact headers `State,Sampling,RootWeight`, one row per observed state. The row order defines MuSSE numeric codes `1,2,...`; use the displayed mapping. `Sampling` is in `(0,1]`. Nonnegative root weights must sum to `1` when **Given** root weights are selected. Example:

```csv
State,Sampling,RootWeight
walking,1,0.4
swimming,1,0.3
flying,1,0.3
```

**Hidden-state Custom indices:** choose two or four hidden classes first. The order is `0A,1A,0B,1B` and, with four classes, `0C,1C,0D,1D`. Turnover indices are a comma-separated vector with one positive integer per state; repeated indices tie parameters, and distinct indices must be consecutive from `1`. Extinction-fraction indices have the same length but may use `0` for a fixed zero. A two-class example is turnover `1,2,3,4` and extinction fraction `1,1,1,1`.

The hidden-state transition indices are a **square CSV matrix without headers** in that same state order. `0` forbids a transition, repeated positive integers tie transition rates, and positive indices must be consecutive. Changes in observed state and hidden class at the same step are forbidden. Click **Fill custom constraints** for a valid matrix, then edit only allowed cells. Do not confuse these index matrices with actual numeric Q rates. Inspect **Effective parameter constraints** in Diagnostics before interpreting the fit.

## Troubleshooting pasted inputs

If a table is rejected, check its exact header spelling, commas, row count, duplicate names, whether you used the current tree's node IDs and state order, and whether a model change made a filled template stale. Regenerate a template after changing states, hidden classes, rate functions or selected regions. A valid input format does not guarantee a converged model. Inspect optimization and posterior diagnostics separately. Never change data solely to make an example fit unless that recoding is scientifically justified and recorded.
