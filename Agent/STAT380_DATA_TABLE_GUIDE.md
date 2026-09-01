# STAT 380 `data.table` Guide

This document describes the default `data.table` style used in STAT 380.

The goal is not to write the shortest possible R code. The goal is to write code that is **clear enough for a student to read, explain, debug, and modify**.

`data.table` is compact by design, but compactness should not come at the expense of understanding.

When several equivalent approaches are available, prefer the one that makes the major steps of the analysis visible.

---

## 1. Load `data.table` Explicitly

Most STAT 380 scripts that manipulate tabular data should begin with:

```r
library(data.table)
```

Do not assume that `data.table` is already attached because it was loaded earlier in an interactive R session.

---

## 2. Read Data with `fread()`

Use `fread()` for tabular source files when appropriate.

For example:

```r
train <- fread(
  "project/volume/data/raw/train.csv"
)

test <- fread(
  "project/volume/data/raw/test.csv"
)
```

Prefer assigning important datasets to clearly named objects such as:

```r
train
test
validation
features
submission
```

Avoid vague names such as:

```r
x
d
tmp
data2
```

unless the meaning is genuinely obvious from a very small local context.

---

## 3. Write Data with `fwrite()`

Use `fwrite()` when writing tabular outputs.

For example:

```r
fwrite(
  submission,
  "project/volume/data/processed/submission.csv"
)
```

The destination should be explicit in the script.

Do not rely on manually exporting objects from RStudio as part of the final reproducible workflow.

---

# The Core `data.table` Pattern

A `data.table` expression has the general form:

```r
DT[i, j, by]
```

It is useful to read this as:

```text
DT[
  which rows,
  what to calculate or return,
  grouped by what
]
```

Not every operation needs all three parts.

For readability, STAT 380 code should often place logically distinct pieces on separate lines.

For example:

```r
summary_dt <- train[
  sale_price > 0,
  .(
    mean_price = mean(sale_price, na.rm = TRUE),
    median_price = median(sale_price, na.rm = TRUE),
    n = .N
  ),
  by = neighborhood
]
```

This is generally preferable in this course to compressing the same logic into one dense line.

---

## 4. Filtering Rows

Filter rows by placing a logical condition in the `i` position.

For example:

```r
adults <- people[
  age >= 18
]
```

Multiple conditions can be written clearly across lines:

```r
high_value <- houses[
  sale_price >= 500000 &
    bedrooms >= 3 &
    year_built >= 2000
]
```

For complex filters, favor readability over minimizing line count.

---

## 5. Selecting Columns

Select columns using `.()`.

For example:

```r
model_data <- train[
  ,
  .(
    sale_price,
    square_feet,
    bedrooms,
    bathrooms
  )
]
```

This makes the selected variables visible and easy to compare with a project rubric or modeling plan.

A shorter form may work, but explicit column lists are often easier for students to understand and defend.

---

## 6. Selecting Columns Programmatically

When column names are stored in a character vector, use `.SDcols`.

For example:

```r
predictor_names <- c(
  "square_feet",
  "bedrooms",
  "bathrooms"
)

x <- train[
  ,
  .SD,
  .SDcols = predictor_names
]
```

This is preferable to clever or opaque column-selection tricks when the purpose is to construct a model matrix or predictor set.

---

## 7. Creating New Columns with `:=`

Use `:=` to add or modify columns by reference.

For example:

```r
train[
  ,
  age_squared := age^2
]
```

Multiple columns can be created together:

```r
train[
  ,
  `:=`(
    age_squared = age^2,
    income_log = log1p(income)
  )
]
```

When the transformation is important to the analysis, give the new variable a descriptive name.

---

## 8. Understand In-Place Modification

`:=` modifies a `data.table` by reference.

For example:

```r
train[
  ,
  age_squared := age^2
]
```

changes `train` itself.

This is different from many base R and tidyverse operations that typically return a new object.

Students should understand whether an operation:

- changes the existing object; or
- creates a new object.

If preserving the original object matters, make an explicit copy:

```r
train_features <- copy(train)

train_features[
  ,
  age_squared := age^2
]
```

Do not use `copy()` everywhere automatically. Use it when preserving the original object has a meaningful purpose.

---

## 9. Grouped Summaries

Use `by` for grouped calculations.

For example:

```r
neighborhood_summary <- train[
  ,
  .(
    mean_price = mean(sale_price, na.rm = TRUE),
    median_price = median(sale_price, na.rm = TRUE),
    n = .N
  ),
  by = neighborhood
]
```

Prefer descriptive output names such as:

```r
mean_price
median_price
n
```

over names such as:

```r
V1
V2
V3
```

---

## 10. Multiple Grouping Variables

Group by multiple variables using `.()`.

For example:

```r
summary_dt <- train[
  ,
  .(
    mean_price = mean(sale_price, na.rm = TRUE),
    n = .N
  ),
  by = .(
    neighborhood,
    property_type
  )
]
```

Use line breaks when they make the grouping structure easier to see.

---

## 11. `.N`

Inside a `data.table` expression, `.N` represents the number of rows in the current group.

For example:

```r
counts <- train[
  ,
  .(
    n = .N
  ),
  by = neighborhood
]
```

Outside grouped operations, `.N` can also be used to refer to the current number of rows within the expression.

---

## 12. `.SD` and `.SDcols`

`.SD` means "Subset of Data."

It is especially useful when applying the same operation across a selected group of columns.

For example:

```r
numeric_columns <- c(
  "square_feet",
  "bedrooms",
  "bathrooms"
)

summary_dt <- train[
  ,
  lapply(
    .SD,
    mean,
    na.rm = TRUE
  ),
  .SDcols = numeric_columns
]
```

Because `.SD` can become difficult to read when overused, prefer it when it clearly reduces repetition rather than simply making code shorter.

---

## 13. Renaming Columns

Use `setnames()` when renaming columns.

For example:

```r
setnames(
  train,
  old = "SalePrice",
  new = "sale_price"
)
```

For multiple columns:

```r
setnames(
  train,
  old = c(
    "SalePrice",
    "GrLivArea"
  ),
  new = c(
    "sale_price",
    "living_area"
  )
)
```

Make renaming operations easy to identify rather than hiding them inside a long chain of transformations.

---

## 14. Ordering Rows

Use `setorder()` when the intention is to reorder an existing `data.table`.

For example:

```r
setorder(
  train,
  -sale_price
)
```

This modifies `train` by reference.

If preserving the previous order matters, make a copy first.

---

## 15. Missing Values

Use explicit missing-value logic.

Examples:

```r
missing_income <- people[
  is.na(income)
]
```

```r
complete_income <- people[
  !is.na(income)
]
```

For summaries:

```r
mean_income <- people[
  ,
  mean(
    income,
    na.rm = TRUE
  )
]
```

Do not add `na.rm = TRUE` automatically without considering what missing values mean in the current problem.

---

## 16. Replacing Missing Values

When replacement is statistically appropriate, make the operation explicit.

For example:

```r
median_income <- median(
  train$income,
  na.rm = TRUE
)

train[
  is.na(income),
  income := median_income
]
```

This is generally more readable for students than embedding the calculation inside a highly compressed expression.

Remember that imputation choices can create data leakage if information from validation or test data is used improperly.

---

# Joins

## 17. Prefer Readable Joins

`data.table` supports powerful join syntax, but joins can be confusing when written too compactly.

When readability matters, use explicit `on =` arguments and clearly named objects.

For example:

```r
result <- customers[
  purchases,
  on = "customer_id"
]
```

Before using a join, students should understand:

- which table is on the left;
- which table is being matched;
- what the join key is;
- what rows are expected to remain.

If the direction of a join is not obvious, explain it in a comment or use a more explicit approach.

---

## 18. Joining on Differently Named Columns

Use a named `on` mapping.

For example:

```r
result <- people[
  gifts,
  on = c(
    "person_id = donor_id"
  )
]
```

This makes the relationship between the two key columns visible.

---

## 19. Avoid Accidental Row Multiplication

Before joining, consider whether the key is unique in each table.

Useful checks include:

```r
people[
  ,
  uniqueN(person_id)
]
```

and:

```r
nrow(people)
```

If a many-to-many join is intended, it should be understood and justified rather than discovered accidentally after the row count expands.

---

# Working with Categories

## 20. Character and Factor Variables

Do not assume that every character column should be converted to a factor.

A character variable may represent:

- a true categorical feature;
- an identifier;
- a name;
- a URL;
- free text;
- a code that only looks numeric or categorical.

Inspect the project context and data profile before deciding how a variable should be represented.

---

## 21. Inspect Category Values

For a reasonably sized categorical variable, inspect the observed values.

For example:

```r
train[
  ,
  sort(
    unique(neighborhood)
  )
]
```

or count them:

```r
train[
  ,
  .(
    n = .N
  ),
  by = neighborhood
][
  order(-n)
]
```

This is especially useful for detecting spelling differences, rare categories, unexpected values, and missing categories.

---

## 22. Recode Categories Explicitly

When categories need to be combined or corrected, make the mapping visible.

For example:

```r
train[
  property_type %in% c(
    "Single Family",
    "Detached"
  ),
  property_type := "Single-family"
]
```

For more substantial recoding, it may be clearer to create a lookup table and join it rather than write many nested conditions.

---

# Training and Test Data

## 23. Apply Compatible Transformations

Training and test data often require the same feature engineering.

Prefer defining transformations clearly enough that they can be applied consistently to both datasets.

For example:

```r
train[
  ,
  age_squared := age^2
]

test[
  ,
  age_squared := age^2
]
```

If the transformation becomes complex, consider putting it in a function.

---

## 24. Use Functions When They Improve Clarity

Functions are useful when the same meaningful operation must be performed repeatedly.

For example:

```r
add_age_features <- function(DT) {

  DT <- copy(DT)

  DT[
    ,
    age_squared := age^2
  ]

  DT[
    ,
    age_log := log1p(age)
  ]

  DT
}
```

Then:

```r
train <- add_age_features(train)
test <- add_age_features(test)
```

Do not create functions merely to make simple one-time code look more sophisticated.

Use a function when it reduces meaningful duplication or makes a repeated transformation safer.

---

# Model Preparation

## 25. Keep the Response Variable Explicit

When preparing supervised-learning data, identify the response separately.

For example:

```r
response_name <- "sale_price"
```

and define predictors explicitly:

```r
predictor_names <- c(
  "square_feet",
  "bedrooms",
  "bathrooms",
  "year_built"
)
```

Then:

```r
x_train <- train[
  ,
  .SD,
  .SDcols = predictor_names
]

y_train <- train[
  ,
  get(response_name)
]
```

This is more readable for students than hiding predictor selection inside a complicated modeling call.

---

## 26. Matrix Conversion

Some modeling packages, including `glmnet` and `xgboost`, commonly require matrix inputs.

For example:

```r
x_train_matrix <- as.matrix(
  x_train
)
```

Make the conversion explicit.

If categorical variables require encoding, handle that step intentionally and consistently between training and test data.

---

# Readability Rules

## 27. Do Not Optimize for Fewest Characters

The following may be valid:

```r
x <- DT[a > 0,.(m=mean(b)),by=c]
```

but it is not the preferred STAT 380 style.

Prefer:

```r
summary_dt <- DT[
  a > 0,
  .(
    mean_b = mean(b)
  ),
  by = c
]
```

The second version is easier to:

- read;
- explain;
- debug;
- modify;
- compare against a rubric;
- discuss with an AI assistant.

---

## 28. Use Line Breaks to Show Structure

A useful default is:

```r
result <- DT[
  row_condition,
  .(
    calculation_1,
    calculation_2
  ),
  by = grouping_variable
]
```

This visually separates:

- row filtering;
- returned calculations;
- grouping.

Very simple operations may remain on one line when they are genuinely clearer that way.

For example:

```r
adults <- people[age >= 18]
```

The goal is readability, not rigid formatting.

---

## 29. Prefer Explicit Intermediate Objects When Helpful

It is acceptable to break a complicated task into several named steps.

For example:

```r
predictor_names <- c(
  "square_feet",
  "bedrooms",
  "bathrooms"
)

x_train <- train[
  ,
  .SD,
  .SDcols = predictor_names
]

x_train_matrix <- as.matrix(
  x_train
)
```

This may be preferable to compressing all three operations into one expression.

Intermediate objects are useful when their names communicate meaningful stages in the analysis.

---

## 30. Avoid Clever Code That Hides the Statistical Task

Do not use advanced `data.table` features merely because they reduce line count.

A student should be able to identify:

- which observations are being used;
- which variables are being selected;
- which new variables are being created;
- what grouping is occurring;
- how tables are being joined;
- what data are ultimately supplied to the model.

If a shorter expression makes those answers harder to see, prefer the longer expression.

---

# Debugging with `data.table`

## 31. Inspect Small Pieces

Useful commands include:

```r
head(train)
```

```r
names(train)
```

```r
str(train)
```

```r
dim(train)
```

```r
summary(train)
```

For selected variables:

```r
train[
  ,
  .(
    square_feet,
    bedrooms,
    sale_price
  )
][
  1:10
]
```

When something goes wrong, inspect the object immediately before the failing step.

---

## 32. Check Dimensions After Major Transformations

After joins, filters, or feature-building steps, verify that dimensions make sense.

For example:

```r
dim(train)
```

or:

```r
nrow(train)
ncol(train)
```

This is particularly important after joins, where unintended duplicate matches can multiply rows.

---

## 33. Check Column Names Before Modeling

Before fitting a model:

```r
names(model_data)
```

and compare them with the intended predictors.

Students should know exactly which columns enter the model rather than allowing that choice to remain implicit.

---

# Using `data.table` with the STAT 380 AI Agent

## 34. Give the Agent the Relevant Context

When asking the agent for help, provide:

- the relevant data profile;
- the project context;
- the current script or code section;
- the exact error or desired transformation.

The agent should not need the full dataset merely to help construct routine `data.table` code.

---

## 35. Ask for Readable Code

The agent should default to code that favors student readability.

Generated code should generally:

- use descriptive object names;
- use explicit relative paths;
- show important column selections;
- break complex `data.table` expressions across lines;
- avoid unnecessary nested expressions;
- explain unfamiliar `data.table` syntax when it is introduced.

A shorter answer is not automatically a better answer.

---

## 36. Understand Generated `data.table` Code

Before incorporating AI-generated code, the student should be able to explain the roles of:

```text
i
j
by
:= 
.SD
.SDcols
.N
on
```

whenever those features appear in the submitted code.

Students do not need to memorize every possible `data.table` feature, but they are responsible for understanding the features used in their own solution.

---

# Default Principle

When choosing between two correct `data.table` solutions, prefer the one that makes the data operation easiest for a STAT 380 student to see and explain.

In this course:

> **Readable, reproducible code is preferred over maximally compact code.**
