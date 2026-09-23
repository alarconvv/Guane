Guane example files

Files:
1. guane_test_tree.nwk
   - Newick phylogenetic tree.
   - 12 tips: sp_01 to sp_12.
   - Use this as the tree file.

2. guane_test_traits.csv
   - Matching trait table.
   - Taxon column: species
   - Response examples: body_mass or wing_length
   - Predictor examples: wing_length or temperature

3. guane_bad_traits_mismatch.csv
   - Intentional validation-test file.
   - Contains sp_99, which is not present in the tree.
   - Use this to test whether Guane detects taxon mismatches.

Suggested Module 1 settings:
- Tree: guane_test_tree.nwk
- Trait table: guane_test_traits.csv
- Taxon column: species
- Response trait: body_mass
- Predictor trait: wing_length
- Response transformation: log
- Predictor transformation: log
- Analyses: Blomberg's K, Pagel's lambda, PIC, PGLS BM, PGLS OU
