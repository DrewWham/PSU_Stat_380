# STAT 380 `data.table` Guide

This document defines the preferred `data.table` practices used in STAT 380.

The goal is not to write the shortest possible R code. The goal is to write code that is **clear enough for a student to read, explain, debug, and modify**.

`data.table` is compact by design, but compactness should not come at the expense of understanding.

When several equivalent approaches are available, prefer the one that makes the major data operation visible.

A central course objective is to build fluency with the core vocabulary of `data.table`. When a task can be expressed clearly with a standard `data.table` function or pattern, prefer that approach over a generic base-R alternative.

---

# Preferred `data.table` Toolkit

The following functions and patterns should be treated as the primary toolkit for routine data manipulation in STAT 380:

- `fread()` — read tabular data
- `fwrite()` — write tabular data
- `DT[i, j, by]` — filter, select, calculate, and group
- `:=` — add or modify columns by reference
- `.SD` and `.SDcols` — work across selected columns
- `.N` — row counts within groups
- `merge()` — readable table joins
- `melt()` — reshape wide data to long form
- `dcast()` — reshape long data to wide form
- `setorder()` — reorder rows
- `setnames()` — rename columns
- `rbindlist()` — combine multiple tables by rows
- `copy()` — explicitly preserve an object before by-reference modification

When helping a student solve a data-manipulation problem, first consider whether one of these standard `data.table` tools directly expresses the task.

Avoid reaching first for generic base-R operations such as `apply()` when a clear `data.table` solution exists.

`lapply()` is an important exception: it is commonly used inside `data.table`, especially with `.SD` and `.SDcols`, and is appropriate when it makes the operation clearer.

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

unless the meaning is genuinely obvious in a very small local context.

---

## 3. Write Data with `fwrite()`

Use `fwrite()` when writing tabular outputs.

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

This is generally preferable to compressing the same logic into one dense line.

---

## 4. Filtering Rows

Filter rows by placing a logical condition in the `i` position.

```r
adults <- people[
  age >= 18
]
```

Multiple conditions can be written across lines:

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

This makes selected variables visible and easy to compare with a project rubric or modeling plan.

---

## 6. Selecting Columns Programmatically with `.SDcols`

When column names are stored in a character vector, use `.SDcols`.

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

This is preferable to opaque column-selection tricks when the purpose is to construct a model matrix or predictor set.

---

## 7. Creating New Columns with `:=`

Use `:=` to add or modify columns by reference.

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

```r
train[
  ,
  age_squared := age^2
]
```

changes `train` itself.

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

```r
counts <- train[
  ,
  .(
    n = .N
  ),
  by = neighborhood
]
```

---

## 12. `.SD`, `.SDcols`, and `lapply()`

`.SD` means "Subset of Data."

It is especially useful when applying the same operation across a selected group of columns.

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

This is an idiomatic `data.table` use of `lapply()`.

Prefer this pattern when the same operation must be applied to a clearly defined set of columns.

Do not replace a direct `data.table` operation with `apply()` merely because `apply()` can technically solve the problem.

For example, if the goal is a grouped summary, use `by`. If the goal is reshaping, use `melt()` or `dcast()`. If the goal is joining, use `merge()` or an explicit `data.table` join.

---

# Joining Tables

## 13. Prefer `merge()` for Readable General Joins

For many STAT 380 tasks, `merge()` is the preferred join function because the two tables, key, and join type are explicit.

For a basic inner join:

```r
combined <- merge(
  students,
  scores,
  by = "student_id"
)
```

For a left join:

```r
combined <- merge(
  students,
  scores,
  by = "student_id",
  all.x = TRUE
)
```

For a full join:

```r
combined <- merge(
  students,
  scores,
  by = "student_id",
  all = TRUE
)
```

Students should be able to explain:

- which two tables are being joined;
- which variable is the key;
- which table's rows are being preserved;
- whether duplicate keys may multiply rows.

---

## 14. Joining on Differently Named Keys

Use `by.x` and `by.y` when the key columns have different names.

```r
combined <- merge(
  people,
  gifts,
  by.x = "person_id",
  by.y = "donor_id",
  all.x = TRUE
)
```

This is often easier for students to read than compact non-equi or keyed join syntax.

---

## 15. Explicit `data.table` Join Syntax Is Also Valid

The bracket join syntax is an important `data.table` feature:

```r
result <- customers[
  purchases,
  on = "customer_id"
]
```

It may be useful when it clearly expresses the intended operation.

However, when a student is still learning joins, `merge()` is often easier to read and explain.

Favor readability over showcasing compact syntax.

---

## 16. Avoid Accidental Row Multiplication

Before joining, consider whether the key is unique.

Useful checks include:

```r
nrow(people)
```

```r
people[
  ,
  uniqueN(person_id)
]
```

and:

```r
people[
  ,
  .N,
  by = person_id
][
  N > 1
]
```

If a many-to-many join is intended, it should be understood and justified rather than discovered accidentally after the row count expands.

---

# Reshaping Data

## 17. Use `melt()` for Wide-to-Long Reshaping

Use `melt()` when columns represent repeated measurements, categories, time points, or related variables that should become rows.

Example wide data:

```text
student_id   exam_1   exam_2   exam_3
1            80       84       88
2            74       79       85
```

Convert to long form:

```r
long_scores <- melt(
  scores,
  id.vars = "student_id",
  measure.vars = c(
    "exam_1",
    "exam_2",
    "exam_3"
  ),
  variable.name = "exam",
  value.name = "score"
)
```

Result:

```text
student_id   exam     score
1            exam_1   80
1            exam_2   84
1            exam_3   88
2            exam_1   74
...
```

Students should understand:

- `id.vars` stay as identifier columns;
- `measure.vars` are collapsed into rows;
- `variable.name` names the new column containing the original column names;
- `value.name` names the new value column.

---

## 18. Use `dcast()` for Long-to-Wide Reshaping

Use `dcast()` when values stored across rows should become separate columns.

Starting from:

```text
student_id   exam     score
1            exam_1   80
1            exam_2   84
1            exam_3   88
```

reshape to wide form:

```r
wide_scores <- dcast(
  long_scores,
  student_id ~ exam,
  value.var = "score"
)
```

Students should be able to read:

```text
student_id ~ exam
```

as:

> one row per `student_id`, with separate columns created from values of `exam`.

---

## 19. Aggregation During `dcast()`

Sometimes more than one row exists for a given row/column combination.

In that case, `dcast()` may require an aggregation function.

For example:

```r
wide_summary <- dcast(
  long_data,
  student_id ~ category,
  value.var = "score",
  fun.aggregate = mean
)
```

Use aggregation intentionally.

Do not add `fun.aggregate` merely to silence a warning without understanding why duplicate combinations exist.

---

## 20. Prefer `melt()` and `dcast()` Over Manual Reshaping

When a task is fundamentally about changing between wide and long form, prefer `melt()` and `dcast()` over:

- manually creating many columns;
- loops that rebuild the table;
- `apply()`-based reshaping;
- custom row-by-row manipulation.

These functions make the structural intention visible.

---

# Combining Tables by Rows

## 21. Use `rbindlist()` for Multiple Tables

When combining multiple compatible tables by rows, prefer `rbindlist()`.

```r
all_years <- rbindlist(
  list(
    data_2024,
    data_2025,
    data_2026
  )
)
```

If columns differ:

```r
all_years <- rbindlist(
  list(
    data_2024,
    data_2025,
    data_2026
  ),
  fill = TRUE
)
```

This is preferable to repeatedly calling `rbind()` in a loop.

---

# Renaming and Ordering

## 22. Renaming Columns with `setnames()`

Use `setnames()` when renaming columns.

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

Make renaming operations easy to identify rather than hiding them inside a long transformation.

---

## 23. Ordering Rows with `setorder()`

Use `setorder()` when the intention is to reorder an existing `data.table`.

```r
setorder(
  train,
  -sale_price
)
```

This modifies the table by reference.

If preserving the previous order matters, make a copy first.

---

# Missing Values

## 24. Identify Missing Values Explicitly

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

Do not add `na.rm = TRUE` automatically without considering what missingness means in the problem.

---

## 25. Replace Missing Values Explicitly

When replacement is statistically appropriate:

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

This is generally easier for students to understand than hiding the calculation inside a highly compressed expression.

Remember that imputation can create data leakage if statistics are calculated using validation or test information inappropriately.

---

# Working with Categories

## 26. Character Does Not Automatically Mean Categorical

A character variable may represent:

- a true category;
- an identifier;
- a name;
- a URL;
- free text;
- a code.

Inspect the project context and data profile before deciding how a variable should be represented.

---

## 27. Inspect Category Values

For a reasonably sized categorical variable:

```r
train[
  ,
  sort(
    unique(neighborhood)
  )
]
```

To inspect frequencies:

```r
category_counts <- train[
  ,
  .(
    n = .N
  ),
  by = neighborhood
]

setorder(
  category_counts,
  -n
)
```

This separates the summary from the ordering step and is easier to explain than nesting multiple operations.

---

## 28. Recode Categories Explicitly

```r
train[
  property_type %in% c(
    "Single Family",
    "Detached"
  ),
  property_type := "Single-family"
]
```

For substantial recoding, consider a lookup table and `merge()` rather than many nested conditions.

---

# Training and Test Data

## 29. Apply Compatible Transformations

Training and test data often require the same feature engineering.

For simple transformations:

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

For repeated complex transformations, a function may improve consistency.

---

## 30. Use Functions When They Improve Clarity

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

Use functions when they reduce meaningful duplication or make repeated transformations safer.

---

# Model Preparation

## 31. Keep the Response Variable Explicit

```r
response_name <- "sale_price"
```

Define predictors explicitly:

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

This is more readable than hiding predictor selection inside a complicated model-fitting call.

---

## 32. Matrix Conversion

Some modeling packages require matrix inputs.

```r
x_train_matrix <- as.matrix(
  x_train
)
```

Make conversion explicit.

If categorical variables require encoding, handle that step intentionally and consistently between training and test data.

---

# Readability Rules

## 33. Do Not Optimize for Fewest Characters

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

## 34. Use Line Breaks to Show Structure

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

```r
adults <- people[age >= 18]
```

The goal is readability, not rigid formatting.

---

## 35. Prefer Explicit Intermediate Objects When Helpful

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

## 36. Avoid Clever Code That Hides the Data Task

Do not use advanced `data.table` features merely because they reduce line count.

A student should be able to identify:

- which observations are being used;
- which variables are being selected;
- which new variables are being created;
- what grouping is occurring;
- how tables are being joined;
- how data are being reshaped;
- what data are ultimately supplied to the model.

If a shorter expression makes those answers harder to see, prefer the longer expression.

---

# Debugging with `data.table`

## 37. Inspect Small Pieces

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

When something goes wrong, inspect the object immediately before the failing step.

---

## 38. Check Dimensions After Major Transformations

After joins, filters, reshaping, or feature-building steps:

```r
dim(train)
```

or:

```r
nrow(train)
ncol(train)
```

This is especially important after joins and casts, where unintended structure can change row or column counts.

---

## 39. Check Column Names Before Modeling

```r
names(model_data)
```

Compare them with the intended predictors.

Students should know exactly which columns enter the model.

---

# Using `data.table` with the STAT 380 AI Agent

## 40. Treat This Guide as the Primary Data-Manipulation Reference

When the agent answers an R data-manipulation question, it should consult this guide and prefer the approaches documented here over generic alternatives.

In particular, the agent should actively consider:

```text
fread
fwrite
DT[i, j, by]
:=
.SD
.SDcols
.N
merge
melt
dcast
rbindlist
setorder
setnames
copy
```

before reaching for a less course-aligned approach.

---

## 41. Give the Agent Relevant Context

When asking for help, provide:

- the relevant data profile;
- the project context;
- the current script or code section;
- the exact error or desired transformation.

The agent should not need the full dataset merely to help construct routine `data.table` code.

---

## 42. Ask for Readable Code

Generated code should generally:

- use descriptive object names;
- use explicit relative paths;
- show important column selections;
- break complex expressions across lines;
- prefer `merge()`, `melt()`, and `dcast()` for joins and reshaping when appropriate;
- avoid unnecessary generic `apply()` solutions;
- explain unfamiliar syntax when it is introduced.

A shorter answer is not automatically a better answer.

---

## 43. Understand Generated `data.table` Code

Before incorporating AI-generated code, the student should be able to explain the roles of:

```text
i
j
by
:=
.SD
.SDcols
.N
merge
melt
dcast
on
```

whenever those features appear in submitted code.

Students do not need to memorize every possible `data.table` feature, but they are responsible for understanding the features used in their own solution.

---

# Default Principle

When choosing between two correct solutions, prefer the one that teaches and reinforces the core `data.table` vocabulary used in STAT 380.

In this course:

> **Readable, reproducible, course-aligned `data.table` code is preferred over maximally compact or generically convenient R code.**
