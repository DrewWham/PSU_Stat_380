library(data.table)

# ==============================================================================
# STAT 380 - Manual Feature Selection Example
# House Prices
#
# Purpose:
#   Explore the training data, manually select a useful set of predictors,
#   and write the selected train/test feature sets to the interim folder.
#
# Contract with the modeling script:
#   Everything written to the interim train/test files is intended to be used
#   by the modeling script.
#
# Workflow:
#   1. Start with a small feature set.
#   2. Screen numeric predictors for association with SalePrice.
#   3. Inspect promising numeric predictors for redundancy/correlation.
#   4. Explore a few categorical predictors.
#   5. Manually revise the selected feature list.
#   6. Write the interim files.
#   7. Run the modeling script, evaluate the result, then return here and revise.
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Load raw data
# ------------------------------------------------------------------------------

train <- fread(
  "./project/volume/data/raw/train.csv"
)

test <- fread(
  "./project/volume/data/raw/test.csv"
)

# ------------------------------------------------------------------------------
# 2. Starting point
# ------------------------------------------------------------------------------

starting_features <- c(
  "OverallCond",
  "GrLivArea"
)

starting_features

# ------------------------------------------------------------------------------
# 3. Numeric screening: relationship with SalePrice
# ------------------------------------------------------------------------------

numeric_columns <- names(train)[
  vapply(
    train,
    is.numeric,
    logical(1)
  )
]

numeric_predictors <- setdiff(
  numeric_columns,
  c(
    "Id",
    "SalePrice"
  )
)

numeric_correlation_matrix <- cor(
  train[
    ,
    .SD,
    .SDcols = c(
      numeric_predictors,
      "SalePrice"
    )
  ],
  use = "pairwise.complete.obs"
)

sale_price_correlations <- data.table(
  feature = numeric_predictors,
  correlation = numeric_correlation_matrix[
    numeric_predictors,
    "SalePrice"
  ]
)

sale_price_correlations[
  ,
  abs_correlation := abs(correlation)
]

setorder(
  sale_price_correlations,
  -abs_correlation
)

print(
  sale_price_correlations
)

# ------------------------------------------------------------------------------
# 4. MANUAL DECISION POINT: promising numeric predictors
# ------------------------------------------------------------------------------

candidate_numeric_features <- c(
  "OverallQual",
  "GrLivArea",
  "GarageCars",
  "GarageArea",
  "TotalBsmtSF",
  "1stFlrSF",
  "FullBath",
  "YearBuilt",
  "YearRemodAdd",
  "TotRmsAbvGrd",
  "Fireplaces",
  "OverallCond"
)

# ------------------------------------------------------------------------------
# 5. Numeric redundancy: correlation among candidate predictors
# ------------------------------------------------------------------------------

candidate_numeric_correlations <- cor(
  train[
    ,
    .SD,
    .SDcols = candidate_numeric_features
  ],
  use = "pairwise.complete.obs"
)

print(
  round(
    candidate_numeric_correlations,
    2
  )
)

# Questions to discuss:
# - Which predictors are strongly related to SalePrice?
# - Which predictors are strongly related to one another?
# - Are two variables mostly measuring the same underlying thing?
# - If two variables are highly correlated, do we need both?
# - Does adding a variable appear to add genuinely new information?

# ------------------------------------------------------------------------------
# 6. MANUAL DECISION POINT: numeric features to keep
# ------------------------------------------------------------------------------

selected_numeric_features <- c(
  "OverallQual",
  "GrLivArea",
  "FullBath",
  "YearBuilt",
  "OverallCond"
)

# ------------------------------------------------------------------------------
# 7. Categorical screening
# ------------------------------------------------------------------------------

candidate_categorical_features <- c(
  "ExterQual",
  "Neighborhood",
  "Foundation",
  "HeatingQC",
  "CentralAir",
  "SaleCondition"
)

for (feature_name in candidate_categorical_features) {

  cat("\n\n")
  cat("============================================================\n")
  cat("Categorical feature:", feature_name, "\n")
  cat("============================================================\n")

  category_summary <- train[
    ,
    .(
      n = .N,
      mean_sale_price = mean(
        SalePrice,
        na.rm = TRUE
      ),
      median_sale_price = median(
        SalePrice,
        na.rm = TRUE
      )
    ),
    by = feature_name
  ]

  setorder(
    category_summary,
    -mean_sale_price
  )

  print(
    category_summary
  )
}

# ------------------------------------------------------------------------------
# 8. MANUAL DECISION POINT: categorical features to keep
# ------------------------------------------------------------------------------

selected_categorical_features <- c(
  "ExterQual",
  "Neighborhood"
)

# ------------------------------------------------------------------------------
# 9. Build the current feature set
# ------------------------------------------------------------------------------

selected_features <- c(
  selected_numeric_features,
  selected_categorical_features
)

cat("\n\nSelected features:\n")

print(
  selected_features
)

# ------------------------------------------------------------------------------
# 10. Check the selected feature set before writing files
# ------------------------------------------------------------------------------

missing_from_train <- setdiff(
  selected_features,
  names(train)
)

missing_from_test <- setdiff(
  selected_features,
  names(test)
)

if (length(missing_from_train) > 0) {
  stop(
    "Selected feature(s) missing from train: ",
    paste(
      missing_from_train,
      collapse = ", "
    )
  )
}

if (length(missing_from_test) > 0) {
  stop(
    "Selected feature(s) missing from test: ",
    paste(
      missing_from_test,
      collapse = ", "
    )
  )
}

train_missing <- data.table(
  feature = selected_features,
  missing = vapply(
    train[
      ,
      .SD,
      .SDcols = selected_features
    ],
    function(x) sum(is.na(x)),
    integer(1)
  )
)

test_missing <- data.table(
  feature = selected_features,
  missing = vapply(
    test[
      ,
      .SD,
      .SDcols = selected_features
    ],
    function(x) sum(is.na(x)),
    integer(1)
  )
)

missing_check <- merge(
  train_missing,
  test_missing,
  by = "feature",
  suffixes = c(
    "_train",
    "_test"
  )
)

print(
  missing_check
)

# ------------------------------------------------------------------------------
# 11. Prepare the interim modeling datasets
# ------------------------------------------------------------------------------

train_features <- train[
  ,
  .SD,
  .SDcols = c(
    selected_features,
    "SalePrice"
  )
]

test_features <- test[
  ,
  .SD,
  .SDcols = selected_features
]

test_features[
  ,
  SalePrice := 0
]

# ------------------------------------------------------------------------------
# 12. Write the interim files
# ------------------------------------------------------------------------------

fwrite(
  train_features,
  "./project/volume/data/interim/train.csv"
)

fwrite(
  test_features,
  "./project/volume/data/interim/test.csv"
)

# ------------------------------------------------------------------------------
# 13. Iteration plan
# ------------------------------------------------------------------------------

# After writing the interim files:
#
#   1. Run the modeling script.
#   2. Record the model/submission result.
#   3. Return to this feature script.
#   4. Revise selected_numeric_features and/or selected_categorical_features.
#   5. Re-run this script.
#   6. Re-run the same modeling script.
#
# The modeling script does not need to change.
#
# Example classroom progression:
#
# Round 1:
#   OverallCond + GrLivArea
#
# Round 2:
#   Add several promising numeric predictors
#
# Round 3:
#   Remove redundant numeric predictors and add one or two categorical predictors
#
# The important lesson is that more predictors increase model flexibility,
# but more complexity does not automatically mean better prediction on new data.
