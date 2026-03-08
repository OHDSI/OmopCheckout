
resultTypeInfo <- dplyr::tribble(
  ~result_type, ~function_name,
  #omopgenerics
  "summarise_log_file", "summariseLogFile",
  "summarise_log_sql", NA,
  #PatientProfiles
  "summarise_table", "summariseResult",
  #IncidencePrevalence
  "incidence", "estimateIncidence",
  "incidence_attrition", "estimateIncidence",
  "summarise_table", "estimatePointPrevalence;estimatePeriodPrevalence",
  "summarise_table", "estimatePointPrevalence;estimatePeriodPrevalence",
  #CodelistGenerator
  "orphan_code_use", "summariseOrphanCodeUse",
  "achilles_code_use", "summariseAchillesCodeUse",
  "code_use", "summariseCodeUse",
  "cohort_code_use", "summariseCohortCodeUse",
  #DrugUtilisation
  "summarise_drug_restart", "summariseDrugRestart",
  "summarise_drug_utilisation", "summariseDrugUtilisation",
  "summarise_treatment", "summariseTreatment",
  "summarise_indication", "summariseIndication",
  "summarise_proportion_of_patients_covered", "summariseProportionOfPatientCovered",
  #CohortCharacteristics
  "summarise_characteristics", "summariseCharacteristics",
  "summarise_cohort_count", "summariseCohortCount",
  "summarise_cohort_attririon", "summariseCohortAttrition",
  "summarise_cohort_overlap", "summariseCohortOverlap",
  "summarise_cohort_timing", "summariseCohortTiming",
  "summarise_large_scale_characteristics", "summariseLargeScaleCharacteristics",
  #CohortSurvival
  "survival_summary", "estimateSingleEventSurvival;estimateCompetingRiskSurvival",
  "survival_attrition", "estimateSingleEventSurvival;estimateCompetingRiskSurvival",
  "survival_estimates", "estimateSingleEventSurvival;estimateCompetingRiskSurvival",
  "survival_events", "estimateSingleEventSurvival;estimateCompetingRiskSurvival",
  #CohortSymmetry
  "sequence_ratios", "summariseSequenceRatios",
  "temporal_symmetry", "summariseTemporalSymmetry",
  #OmopSketch
  "summarise_clinical_records", "sumariseClinicalRecords",
  "summarise_concept_id_counts", "summariseConceptIdCounts",
  "summarise_concept_set_counts", "summariseConceptSetCounts",
  "summarise_trend", "summariseTrend",
  "summarise_missing_data", "summariseMissingData",
  "summarise_observation_period", "summariseObservationPeriod",
  "summarise_person", "summarisePerson",
  "summarise_omop_snapshot", "summariseOmopSnapshot",
  #MeasurementDiagnostics
  "measurement_summary", "summariseMeasurementUse;summariseCohortMeasurementUse",
  "measurement_value_as_concept", "summariseMeasurementUse;summariseCohortMeasurementUse",
  "measurement_value_as_number", "summariseMeasurementUse;summariseCohortMeasurementUse"
)

pkgsInfo <- dplyr::tribble(
  ~package_name, ~package_website,
  #omopgenerics
  "omopgenerics", "https://darwin-eu.github.io/omopgenerics/",
  #PatientProfiles
  "PatientProfiles", "https://darwin-eu.github.io/PatientProfiles/",
  #IncidencePrevalence
  "IncidencePrevalence", "https://darwin-eu.github.io/IncidencePrevalence/",
  #CodelistGenerator
  "CodelistGenerator", "https://darwin-eu.github.io/CodelistGenerator/",
  #DrugUtilisation
  "DrugUtilisation", "https://darwin-eu.github.io/DrugUtilisation/",
  #CohortCharacteristics
  "CohortCharacteristics", "https://darwin-eu.github.io/CohortCharacteristics/",
  #CohortSurvival
  "CohortSurvival", "https://darwin-eu.github.io/CohortSurvival/",
  #CohortSymmetry
  "CohortSymmetry", "https://ohdsi.github.io/CohortSymmetry/",
  #OmopSketch
  "OmopSketch", "https://ohdsi.github.io/OmopSketch/",
  #MeasurementDiagnostics
  "MeasurementDiagnostics", "https://ohdsi.github.io/MeasurementDiagnostics/"
)

usethis::use_data(resultTypeInfo, pkgsInfo, overwrite = TRUE, internal = TRUE)
