# STAT 380 Coding Conventions

This document describes the default coding conventions used in STAT 380 projects.

These conventions are intended to make student work easier to understand, reproduce, debug, and extend. They also provide a consistent framework for AI-assisted development.

Project-specific instructions may override these defaults when necessary.

---

## 1. Working Directory

The **named Git repository directory is the working directory**.

The generic `project/` folder is a structural container inside the repository. It is not the expected working directory.

For example, if a repository is named:

```text
house_price_project/
```

then code should be run from:

```text
house_price_project/
```

and paths to project resources should begin with:

```text
project/
```

For example:

```r
train <- data.table::fread(
  "project/volume/data/raw/train.csv"
)
```

Do not assume that code is run from inside the generic `project/` folder.

---

## 2. Primary Language and Data-Manipulation Framework

STAT 380 projects are developed primarily in **R**.

For routine tabular data manipulation, use `data.table` as the default framework.

The primary reference for data-manipulation syntax and preferred approaches is:

```text
STAT380_DATA_TABLE_GUIDE.md
```

When solving a data-manipulation problem, prefer the approaches documented in that guide over generic R alternatives.

In particular, the course expects students to become familiar with core `data.table` tools such as:

- `fread()`
- `fwrite()`
- `DT[i, j, by]`
- `:=`
- `.SD`
- `.SDcols`
- `.N`
- `merge()`
- `melt()`
- `dcast()`
- `rbindlist()`
- `setorder()`
- `setnames()`
- `copy()`

Do not default to generic base-R approaches such as `apply()` when a clear course-aligned `data.table` solution exists.

Other packages may be used when appropriate to the statistical or computational task, but routine data manipulation should generally follow the `data.table` conventions documented for the course.

Prefer clear, direct code over unnecessarily elaborate abstractions.

---

## 3. Use the Project Structure

Code should fit into the standard STAT 380 project template.

Typical locations are:

```text
project/src/data/       <- data utilities and profiling
project/src/features/   <- cleaning, transformations, feature engineering
project/src/models/     <- model fitting, evaluation, and prediction
```

Data and generated artifacts belong under:

```text
project/volume/
```

Do not scatter scripts, data files, or model outputs throughout the repository.

---

## 4. Use Relative Paths

Project code should use paths relative to the named repository root.

Prefer:

```r
train <- data.table::fread(
  "project/volume/data/raw/train.csv"
)
```

rather than:

```r
train <- data.table::fread(
  "/Users/name/Desktop/house_price_project/project/volume/data/raw/train.csv"
)
```

or:

```r
train <- data.table::fread(
  "C:/Users/name/Documents/house_price_project/project/volume/data/raw/train.csv"
)
```

Do not use `setwd()` as part of the normal workflow.

The project should remain portable if the repository is moved or cloned to another computer.

---

## 5. Raw Data Are Read-Only

Original data belong in:

```text
project/volume/data/raw/
```

Do not overwrite or manually edit raw data files.

If data are cleaned, joined, recoded, or transformed, write the resulting resources to:

```text
project/volume/data/interim/
```

or:

```text
project/volume/data/processed/
```

as appropriate.

A reproducible project should make it possible to regenerate transformed data from the original raw inputs.

---

## 6. Read and Write Data Explicitly

For tabular data, prefer course-aligned `data.table` functions:

```r
library(data.table)

train <- fread(
  "project/volume/data/raw/train.csv"
)
```

and:

```r
fwrite(
  predictions,
  "project/volume/data/processed/submission.csv"
)
```

File reads and writes should be visible in the code rather than hidden in manual steps performed outside the project.

---

## 7. Prefer Core `data.table` Operations for Data Work

When a task can be handled clearly with the core `data.table` toolkit, prefer that approach.

Examples include:

- use `merge()` for readable joins;
- use `melt()` for wide-to-long reshaping;
- use `dcast()` for long-to-wide reshaping;
- use `rbindlist()` to combine multiple compatible tables by rows;
- use `DT[i, j, by]` for filtering, selecting, summarizing, and grouping;
- use `:=` for in-place column creation or modification;
- use `.SD` and `.SDcols` for repeated operations across selected columns.

Do not introduce a generic alternative merely because it is shorter or familiar.

The goal is to reinforce the course's shared `data.table` vocabulary.

For details and examples, consult:

```text
STAT380_DATA_TABLE_GUIDE.md
```

---

## 8. Preserve Clear Object Roles

Use object names that communicate purpose.

Prefer:

```r
train
test
features
model
predictions
submission
```

over vague names such as:

```r
x1
temp2
stuff
final_final
```

Temporary objects are fine during development, but final scripts should make the main workflow understandable.

---

## 9. Keep Training and Test Data Distinct

In supervised-learning projects, preserve a clear distinction between:

- training data, where the response is observed;
- validation data, when used;
- test data, where the response is hidden.

Do not use hidden test outcomes or information that would not be available at prediction time.

If train and test data are temporarily combined for a legitimate transformation, preserve a reliable way to separate them again.

---

## 10. Make Feature Construction Reproducible

Feature engineering should be implemented in code.

Do not rely on undocumented manual editing of datasets.

When practical, feature-building scripts should read from:

```text
project/volume/data/raw/
```

or:

```text
project/volume/data/interim/
```

and write reusable outputs to:

```text
project/volume/data/interim/
```

or:

```text
project/volume/data/processed/
```

The same transformation logic should be applied consistently to training and test data when appropriate.

---

## 11. Make Randomness Reproducible

When a result depends on randomness, use an explicit seed.

For example:

```r
set.seed(380)
```

This is especially important for:

- train/validation splits;
- resampling;
- cross-validation folds;
- randomized algorithms;
- stochastic model fitting.

Use the seed before the operation whose randomness should be reproduced.

---

## 12. Document Dependencies

Required R packages should be listed in:

```text
project/required/requirements.R
```

Load packages explicitly in scripts when they are used.

For example:

```r
library(data.table)
library(glmnet)
library(xgboost)
```

Do not assume that a package is attached simply because it was used earlier in an interactive R session.

---

## 13. Write Scripts That Can Run from a Clean Session

Final project scripts should not depend on objects that happen to exist in the student's current R environment.

A script should create or load the objects it needs.

Avoid workflows such as:

```r
fit <- glmnet(model_matrix, y)
```

when the script itself never creates or loads `model_matrix` or `y`.

A useful test is to restart R and run the declared project workflow again from the named repository root.

---

## 14. Preserve Development History

It is acceptable, and often useful, for `project/src/` to contain:

- exploratory scripts;
- alternative modeling approaches;
- intermediate attempts;
- code that was ultimately not used.

Do not delete useful evidence of the development process simply to make the repository appear cleaner.

The final intended workflow is declared separately in:

```text
project/entry_point.sh
```

---

## 15. Keep `entry_point.sh` Current

`project/entry_point.sh` should identify the scripts required to reproduce the final project result and the order in which they should run.

Because the named repository root is the working directory, commands inside `entry_point.sh` should also use repository-root-relative paths.

For example:

```bash
Rscript project/src/features/01_build_features.R
Rscript project/src/models/01_train_model.R
Rscript project/src/models/02_create_submission.R
```

The entry point itself should normally be run from the named repository root:

```bash
bash project/entry_point.sh
```

If the final workflow changes, update `entry_point.sh`.

The presence of a script in `project/src/` does not automatically mean it belongs in the final pipeline.

---

## 16. Prefer Incremental Scripts Over One Giant Script

A small project may reasonably use one feature script and one modeling script.

As a project becomes more complex, it is appropriate to divide the workflow into multiple clearly named stages.

For example:

```text
project/src/features/
├── 01_clean_data.R
├── 02_build_features.R
└── 03_prepare_model_matrix.R
```

The goal is not to maximize the number of files. The goal is to make the workflow understandable.

---

## 17. Comments Should Explain Decisions

Use comments to explain:

- why a transformation is being performed;
- why a modeling choice was made;
- assumptions that are not obvious from the code;
- unusual implementation details.

Avoid comments that merely translate obvious code into English.

Less useful:

```r
# Calculate age squared
DT[, age_squared := age^2]
```

More useful:

```r
# Allow the model to represent a nonlinear relationship between age and price.
DT[, age_squared := age^2]
```

---

## 18. Use Data Profiles as Project Context

Project datasets should be profiled using:

```text
project/src/data/profile_data.R
```

Run the profiler from the named repository root:

```bash
Rscript project/src/data/profile_data.R
```

Generated profiles are written to:

```text
project/volume/data/profiles/
```

Before asking an AI assistant to reason about a dataset, provide the relevant generated profile when available.

A data profile does not replace exploratory analysis, but it should provide enough structural information to begin working intelligently.

---

## 19. Inspect Before Replacing Existing Code

When working with an AI assistant, provide relevant existing code before asking for a replacement.

The preferred pattern is:

1. understand the current script;
2. identify the specific problem;
3. modify the smallest appropriate portion;
4. verify that the change remains compatible with the rest of the project.

Avoid replacing an entire working project with a completely different implementation unless there is a clear reason to do so.

---

## 20. Code Should Be Understandable by the Student

AI-generated code is allowed during project development, but students remain responsible for understanding the code they submit.

Before keeping generated code, students should be able to explain:

- what objects it creates;
- what data it uses;
- what each major transformation accomplishes;
- what model is being fit;
- what outcome is being predicted;
- how predictions are generated;
- where outputs are written;
- how the script fits into the declared workflow.

Code that works but cannot be understood or defended is not a successful STAT 380 solution.

---

## 21. Prefer Reproducibility Over Convenience

When choosing between:

- a manual shortcut that works once; and
- a coded process that can be rerun,

prefer the reproducible coded process.

The final project should make the relationship between source data, code, models, and outputs visible.

A student should be able to return to the named repository root and reproduce the intended workflow using:

```bash
bash project/entry_point.sh
```

when the required project data and dependencies are available.

---

## 22. Project-Specific Instructions Take Priority

These conventions are defaults.

If `project/PROJECT_CONTEXT.md`, the project rubric, or assignment instructions specify a different requirement, follow the project-specific instruction.

Do not invent requirements that are not present in the course or project materials.
