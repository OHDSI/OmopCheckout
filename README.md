
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OmopCheckout <a href="https://OHDSI.github.io/OmopCheckout/"><img src="man/figures/logo.png" align="right" height="120" alt="OmopCheckout website" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/OmopCheckout)](https://CRAN.R-project.org/package=OmopCheckout)
[![R-CMD-check](https://github.com/OHDSI/OmopCheckout/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/OHDSI/OmopCheckout/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of **OmopCheckout** is to … *clearly state the main goal of the
package*

## Installation

You can install the development version of OmopCheckout from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pkg_install("OHDSI/OmopCheckout")
```

## Example

``` r
library(OmopCheckout)
library(OmopViewer)

checkout(omopViewerResults)
#> ## <summarised_result>
#> 
#> ### Suppression
#> 
#> - Results suppressed with **minCellCount = 5** for result IDs: 1–122 (55,103 rows; 100.0%)
#> 
#> ### Packages
#> 
#> **CodelistGenerator (3.5.0)** for result IDs: 6–10 (183 rows ; 0.3%):
#> 
#> - *achilles_code_use* for result IDs: 6–10 (12 rows ; <0.1%)
#> - *code_use* for result IDs: 6–10 (24 rows ; <0.1%)
#> - *cohort_code_use* for result IDs: 6–10 (144 rows ; 0.3%)
#> - *orphan_code_use* for result IDs: 6–10 (2 rows ; <0.1%)
#> - *unmapped_codes* for result IDs: 6–10 (1 rows ; <0.1%)
#> 
#> **CohortCharacteristics (1.1.0)** for result IDs: 11–17 (31,413 rows ; 57.0%):
#> 
#> - *summarise_characteristics* for result IDs: 11–17 (63 rows ; 0.1%)
#> - *summarise_cohort_attrition* for result IDs: 11–17 (16 rows ; <0.1%)
#> - *summarise_cohort_count* for result IDs: 11–17 (2 rows ; <0.1%)
#> - *summarise_cohort_overlap* for result IDs: 11–17 (180 rows ; 0.3%)
#> - *summarise_cohort_timing* for result IDs: 11–17 (30,930 rows ; 56.1%)
#> - *summarise_large_scale_characteristics* for result IDs: 11–17 (222 rows ; 0.4%)
#> 
#> **CohortSurvival (1.1.0)** for result IDs: 96–115 (7,038 rows ; 12.8%):
#> 
#> - *survival_attrition* for result IDs: 96–115 (84 rows ; 0.2%)
#> - *survival_estimates* for result IDs: 96–115 (6,588 rows ; 12.0%)
#> - *survival_events* for result IDs: 96–115 (252 rows ; 0.5%)
#> - *survival_summary* for result IDs: 96–115 (114 rows ; 0.2%)
#> 
#> **DrugUtilisation (1.0.5)** for result IDs: 90–95 (339 rows ; 0.6%):
#> 
#> - *summarise_dose_coverage* for result IDs: 90–95 (32 rows ; 0.1%)
#> - *summarise_drug_restart* for result IDs: 90–95 (24 rows ; <0.1%)
#> - *summarise_drug_utilisation* for result IDs: 90–95 (72 rows ; 0.1%)
#> - *summarise_indication* for result IDs: 90–95 (36 rows ; 0.1%)
#> - *summarise_proportion_of_patients_covered* for result IDs: 90–95 (115 rows ; 0.2%)
#> - *summarise_treatment* for result IDs: 90–95 (60 rows ; 0.1%)
#> 
#> **IncidencePrevalence (1.2.1)** for result IDs: 18–89 (3,696 rows ; 6.7%):
#> 
#> - *incidence* for result IDs: 18–89 (1,176 rows ; 2.1%)
#> - *incidence_attrition* for result IDs: 18–89 (840 rows ; 1.5%)
#> - *prevalence* for result IDs: 18–89 (840 rows ; 1.5%)
#> - *prevalence_attrition* for result IDs: 18–89 (840 rows ; 1.5%)
#> 
#> **MeasurementDiagnostics (0.2.0)** for result IDs: 117–122 (8,312 rows ; 15.1%):
#> 
#> - *measurement_summary* for result IDs: 117–122 (2,080 rows ; 3.8%)
#> - *measurement_value_as_concept* for result IDs: 117–122 (16 rows ; <0.1%)
#> - *measurement_value_as_number* for result IDs: 117–122 (6,216 rows ; 11.3%)
#> 
#> **OmopSketch (1.0.0)** for result IDs: 1–5 (4,049 rows ; 7.3%):
#> 
#> - *summarise_clinical_records* for result IDs: 1–5 (186 rows ; 0.3%)
#> - *summarise_missing_data* for result IDs: 1–5 (114 rows ; 0.2%)
#> - *summarise_observation_period* for result IDs: 1–5 (3,126 rows ; 5.7%)
#> - *summarise_omop_snapshot* for result IDs: 1–5 (15 rows ; <0.1%)
#> - *summarise_trend* for result IDs: 1–5 (608 rows ; 1.1%)
#> 
#> **omopgenerics (1.3.5)** for result IDs: 116 (73 rows ; 0.1%):
#> 
#> - *summarise_log_file* for result IDs: 116 (73 rows ; 0.1%)
#> 
#> 
#> ### Estimates
#> 
#> **achilles_code_use** for result IDs: 9 (12 rows ; <0.1%):
#> 
#> - *person_count* (6 rows; <0.1%)
#> - *record_count* (6 rows; <0.1%)
#> 
#> **code_use** for result IDs: 8 (24 rows ; <0.1%):
#> 
#> - *person_count* (12 rows; <0.1%)
#> - *record_count* (12 rows; <0.1%)
#> 
#> **cohort_code_use** for result IDs: 7 (144 rows ; 0.3%):
#> 
#> - *person_count* (72 rows; 0.1%)
#> - *record_count* (72 rows; 0.1%)
#> 
#> **incidence** for result IDs: 18–35 (1,176 rows ; 2.1%):
#> 
#> - *denominator_count* (168 rows; 0.3%)
#> - *incidence_100000_pys* (168 rows; 0.3%)
#> - *incidence_100000_pys_95CI_lower* (168 rows; 0.3%)
#> - *incidence_100000_pys_95CI_upper* (168 rows; 0.3%)
#> - *outcome_count* (168 rows; 0.3%)
#> - *person_days* (168 rows; 0.3%)
#> - *person_years* (168 rows; 0.3%)
#> 
#> **incidence_attrition** for result IDs: 36–53 (840 rows ; 1.5%):
#> 
#> - *count* (840 rows; 1.5%)
#> 
#> **measurement_summary** for result IDs: 117, 120 (2,080 rows ; 3.8%):
#> 
#> - *count* (6 rows; <0.1%)
#> - *density_x* (1027 rows; 1.9%)
#> - *density_y* (1027 rows; 1.9%)
#> - *max* (4 rows; <0.1%)
#> - *median* (4 rows; <0.1%)
#> - *min* (4 rows; <0.1%)
#> - *q25* (4 rows; <0.1%)
#> - *q75* (4 rows; <0.1%)
#> 
#> **measurement_value_as_concept** for result IDs: 119, 122 (16 rows ; <0.1%):
#> 
#> - *count* (8 rows; <0.1%)
#> - *percentage* (8 rows; <0.1%)
#> 
#> **measurement_value_as_number** for result IDs: 118, 121 (6,216 rows ; 11.3%):
#> 
#> - *count* (6 rows; <0.1%)
#> - *count_missing* (6 rows; <0.1%)
#> - *density_x* (3072 rows; 5.6%)
#> - *density_y* (3072 rows; 5.6%)
#> - *max* (6 rows; <0.1%)
#> - *median* (6 rows; <0.1%)
#> - *min* (6 rows; <0.1%)
#> - *percentage_missing* (6 rows; <0.1%)
#> - *q01* (6 rows; <0.1%)
#> - *q05* (6 rows; <0.1%)
#> - *q25* (6 rows; <0.1%)
#> - *q75* (6 rows; <0.1%)
#> - *q95* (6 rows; <0.1%)
#> - *q99* (6 rows; <0.1%)
#> 
#> **orphan_code_use** for result IDs: 6 (2 rows ; <0.1%):
#> 
#> - *person_count* (1 rows; <0.1%)
#> - *record_count* (1 rows; <0.1%)
#> 
#> **prevalence** for result IDs: 54–71 (840 rows ; 1.5%):
#> 
#> - *denominator_count* (168 rows; 0.3%)
#> - *outcome_count* (168 rows; 0.3%)
#> - *prevalence* (168 rows; 0.3%)
#> - *prevalence_95CI_lower* (168 rows; 0.3%)
#> - *prevalence_95CI_upper* (168 rows; 0.3%)
#> 
#> **prevalence_attrition** for result IDs: 72–89 (840 rows ; 1.5%):
#> 
#> - *count* (840 rows; 1.5%)
#> 
#> **summarise_characteristics** for result IDs: 14 (63 rows ; 0.1%):
#> 
#> - *count* (10 rows; <0.1%)
#> - *max* (7 rows; <0.1%)
#> - *mean* (5 rows; <0.1%)
#> - *median* (7 rows; <0.1%)
#> - *min* (7 rows; <0.1%)
#> - *percentage* (8 rows; <0.1%)
#> - *q25* (7 rows; <0.1%)
#> - *q75* (7 rows; <0.1%)
#> - *sd* (5 rows; <0.1%)
#> 
#> **summarise_clinical_records** for result IDs: 3 (186 rows ; 0.3%):
#> 
#> - *count* (30 rows; 0.1%)
#> - *max* (2 rows; <0.1%)
#> - *mean* (2 rows; <0.1%)
#> - *median* (2 rows; <0.1%)
#> - *min* (2 rows; <0.1%)
#> - *na_count* (39 rows; 0.1%)
#> - *na_percentage* (39 rows; 0.1%)
#> - *percentage* (28 rows; 0.1%)
#> - *q25* (2 rows; <0.1%)
#> - *q75* (2 rows; <0.1%)
#> - *sd* (2 rows; <0.1%)
#> - *zero_count* (18 rows; <0.1%)
#> - *zero_percentage* (18 rows; <0.1%)
#> 
#> **summarise_cohort_attrition** for result IDs: 13 (16 rows ; <0.1%):
#> 
#> - *count* (16 rows; <0.1%)
#> 
#> **summarise_cohort_count** for result IDs: 12 (2 rows ; <0.1%):
#> 
#> - *count* (2 rows; <0.1%)
#> 
#> **summarise_cohort_overlap** for result IDs: 11 (180 rows ; 0.3%):
#> 
#> - *count* (90 rows; 0.2%)
#> - *percentage* (90 rows; 0.2%)
#> 
#> **summarise_cohort_timing** for result IDs: 15 (30,930 rows ; 56.1%):
#> 
#> - *count* (60 rows; 0.1%)
#> - *density_x* (15360 rows; 27.9%)
#> - *density_y* (15360 rows; 27.9%)
#> - *max* (30 rows; 0.1%)
#> - *median* (30 rows; 0.1%)
#> - *min* (30 rows; 0.1%)
#> - *q25* (30 rows; 0.1%)
#> - *q75* (30 rows; 0.1%)
#> 
#> **summarise_dose_coverage** for result IDs: 91 (32 rows ; 0.1%):
#> 
#> - *count* (4 rows; <0.1%)
#> - *count_missing* (4 rows; <0.1%)
#> - *mean* (4 rows; <0.1%)
#> - *median* (4 rows; <0.1%)
#> - *percentage_missing* (4 rows; <0.1%)
#> - *q25* (4 rows; <0.1%)
#> - *q75* (4 rows; <0.1%)
#> - *sd* (4 rows; <0.1%)
#> 
#> **summarise_drug_restart** for result IDs: 94 (24 rows ; <0.1%):
#> 
#> - *count* (12 rows; <0.1%)
#> - *percentage* (12 rows; <0.1%)
#> 
#> **summarise_drug_utilisation** for result IDs: 93 (72 rows ; 0.1%):
#> 
#> - *count* (2 rows; <0.1%)
#> - *count_missing* (10 rows; <0.1%)
#> - *mean* (10 rows; <0.1%)
#> - *median* (10 rows; <0.1%)
#> - *percentage_missing* (10 rows; <0.1%)
#> - *q25* (10 rows; <0.1%)
#> - *q75* (10 rows; <0.1%)
#> - *sd* (10 rows; <0.1%)
#> 
#> **summarise_indication** for result IDs: 92 (36 rows ; 0.1%):
#> 
#> - *count* (18 rows; <0.1%)
#> - *percentage* (18 rows; <0.1%)
#> 
#> **summarise_large_scale_characteristics** for result IDs: 16–17 (222 rows ; 0.4%):
#> 
#> - *count* (111 rows; 0.2%)
#> - *percentage* (111 rows; 0.2%)
#> 
#> **summarise_log_file** for result IDs: 116 (73 rows ; 0.1%):
#> 
#> - *date_time* (37 rows; 0.1%)
#> - *elapsed_time* (36 rows; 0.1%)
#> 
#> **summarise_missing_data** for result IDs: 4 (114 rows ; 0.2%):
#> 
#> - *na_count* (39 rows; 0.1%)
#> - *na_percentage* (39 rows; 0.1%)
#> - *zero_count* (18 rows; <0.1%)
#> - *zero_percentage* (18 rows; <0.1%)
#> 
#> **summarise_observation_period** for result IDs: 2 (3,126 rows ; 5.7%):
#> 
#> - *count* (7 rows; <0.1%)
#> - *density_x* (1536 rows; 2.8%)
#> - *density_y* (1536 rows; 2.8%)
#> - *max* (3 rows; <0.1%)
#> - *mean* (3 rows; <0.1%)
#> - *median* (3 rows; <0.1%)
#> - *min* (3 rows; <0.1%)
#> - *na_count* (5 rows; <0.1%)
#> - *na_percentage* (5 rows; <0.1%)
#> - *percentage* (4 rows; <0.1%)
#> - *q05* (3 rows; <0.1%)
#> - *q25* (3 rows; <0.1%)
#> - *q75* (3 rows; <0.1%)
#> - *q95* (3 rows; <0.1%)
#> - *sd* (3 rows; <0.1%)
#> - *zero_count* (3 rows; <0.1%)
#> - *zero_percentage* (3 rows; <0.1%)
#> 
#> **summarise_omop_snapshot** for result IDs: 1 (15 rows ; <0.1%):
#> 
#> - *count* (1 rows; <0.1%)
#> - *description* (1 rows; <0.1%)
#> - *documentation_reference* (1 rows; <0.1%)
#> - *end_date* (1 rows; <0.1%)
#> - *holder_name* (1 rows; <0.1%)
#> - *package* (1 rows; <0.1%)
#> - *person_count* (1 rows; <0.1%)
#> - *release_date* (1 rows; <0.1%)
#> - *snapshot_date* (1 rows; <0.1%)
#> - *source_name* (1 rows; <0.1%)
#> - *start_date* (1 rows; <0.1%)
#> - *type* (1 rows; <0.1%)
#> - *version* (1 rows; <0.1%)
#> - *vocabulary_version* (1 rows; <0.1%)
#> - *write_schema* (1 rows; <0.1%)
#> 
#> **summarise_proportion_of_patients_covered** for result IDs: 90 (115 rows ; 0.2%):
#> 
#> - *denominator_count* (23 rows; <0.1%)
#> - *outcome_count* (23 rows; <0.1%)
#> - *ppc* (23 rows; <0.1%)
#> - *ppc_lower* (23 rows; <0.1%)
#> - *ppc_upper* (23 rows; <0.1%)
#> 
#> **summarise_treatment** for result IDs: 95 (60 rows ; 0.1%):
#> 
#> - *count* (30 rows; 0.1%)
#> - *percentage* (30 rows; 0.1%)
#> 
#> **summarise_trend** for result IDs: 5 (608 rows ; 1.1%):
#> 
#> - *count* (304 rows; 0.6%)
#> - *percentage* (304 rows; 0.6%)
#> 
#> **survival_attrition** for result IDs: 108–111, 115 (84 rows ; 0.2%):
#> 
#> - *count* (84 rows; 0.2%)
#> 
#> **survival_estimates** for result IDs: 96–99, 112 (6,588 rows ; 12.0%):
#> 
#> - *estimate* (2196 rows; 4.0%)
#> - *estimate_95CI_lower* (2196 rows; 4.0%)
#> - *estimate_95CI_upper* (2196 rows; 4.0%)
#> 
#> **survival_events** for result IDs: 100–103, 113 (252 rows ; 0.5%):
#> 
#> - *n_censor_count* (84 rows; 0.2%)
#> - *n_events_count* (84 rows; 0.2%)
#> - *n_risk_count* (84 rows; 0.2%)
#> 
#> **survival_summary** for result IDs: 104–107, 114 (114 rows ; 0.2%):
#> 
#> - *median_survival* (4 rows; <0.1%)
#> - *median_survival_95CI_higher* (4 rows; <0.1%)
#> - *median_survival_95CI_lower* (4 rows; <0.1%)
#> - *n_events_count* (6 rows; <0.1%)
#> - *number_records_count* (6 rows; <0.1%)
#> - *q05_survival* (4 rows; <0.1%)
#> - *q05_survival_95CI_higher* (4 rows; <0.1%)
#> - *q05_survival_95CI_lower* (4 rows; <0.1%)
#> - *q0_survival* (4 rows; <0.1%)
#> - *q0_survival_95CI_higher* (4 rows; <0.1%)
#> - *q0_survival_95CI_lower* (4 rows; <0.1%)
#> - *q100_survival* (4 rows; <0.1%)
#> - *q100_survival_95CI_higher* (4 rows; <0.1%)
#> - *q100_survival_95CI_lower* (4 rows; <0.1%)
#> - *q25_survival* (4 rows; <0.1%)
#> - *q25_survival_95CI_higher* (4 rows; <0.1%)
#> - *q25_survival_95CI_lower* (4 rows; <0.1%)
#> - *q75_survival* (4 rows; <0.1%)
#> - *q75_survival_95CI_higher* (4 rows; <0.1%)
#> - *q75_survival_95CI_lower* (4 rows; <0.1%)
#> - *q95_survival* (4 rows; <0.1%)
#> - *q95_survival_95CI_higher* (4 rows; <0.1%)
#> - *q95_survival_95CI_lower* (4 rows; <0.1%)
#> - *restricted_mean_survival* (6 rows; <0.1%)
#> - *restricted_mean_survival_95CI_lower* (6 rows; <0.1%)
#> - *restricted_mean_survival_95CI_upper* (6 rows; <0.1%)
#> 
#> **unmapped_codes** for result IDs: 10 (1 rows ; <0.1%):
#> 
#> - *record_count* (1 rows; <0.1%)
```
