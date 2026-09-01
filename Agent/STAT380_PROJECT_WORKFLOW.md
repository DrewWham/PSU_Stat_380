# STAT 380 Project Workflow

This document describes the standard workflow for STAT 380 projects and the role of the STAT 380 AI Studio agent within that workflow.

The goal is to give students a repeatable way to begin, develop, debug, and complete projects while keeping the work organized, reproducible, and understandable.

Project-specific instructions may modify individual steps, but this workflow should be treated as the default.

---

## 1. Start from the STAT 380 Project Template

Begin each project by creating a new project from the standard STAT 380 project template.

The named Git repository directory is the working directory.

A typical project begins with a structure similar to:

```text
project_name/
├── README.md
├── AGENTS.md
├── .gitignore
│
└── project/
    ├── PROJECT_CONTEXT.md
    ├── entry_point.sh
    │
    ├── volume/
    │   ├── data/
    │   │   ├── raw/
    │   │   ├── interim/
    │   │   ├── processed/
    │   │   └── profiles/
    │   └── models/
    │
    ├── required/
    │   └── requirements.R
    │
    └── src/
        ├── data/
        ├── features/
        └── models/
```

Do not begin by placing files arbitrarily on the desktop or by building a disconnected script outside the project structure.

---

## 2. Obtain the Project Data

Download the data from the location specified by the assignment.

This may be Kaggle or another course-provided source.

Place the original supplied data files in:

```text
project/volume/data/raw/
```

Raw data should remain unchanged.

Do not manually edit, overwrite, or clean the original files in place.

---

## 3. Profile the Data

Before substantial coding begins, run the standard data profiler from the named repository root:

```bash
Rscript project/src/data/profile_data.R
```

The profiler reads the files in:

```text
project/volume/data/raw/
```

and writes compact Markdown profiles to:

```text
project/volume/data/profiles/
```

The generated profiles summarize information such as:

- dataset dimensions;
- column names;
- R data types;
- missingness;
- unique-value counts;
- representative values;
- numeric summaries;
- reasonably enumerable categorical values;
- simple structural flags.

The profile is not a substitute for exploratory data analysis.

Its purpose is to create a compact description of the data that is useful to both the student and the AI Studio agent.

---

## 4. Describe the Project

Complete or replace:

```text
project/PROJECT_CONTEXT.md
```

with the important facts about the current project.

This should usually identify:

- the project objective;
- relevant data files;
- training and test data, when applicable;
- the response or target variable;
- important identifiers;
- the evaluation metric;
- expected outputs;
- project constraints;
- submission requirements.

Keep this document concise.

Its purpose is to communicate what problem is being solved, not to document every decision made during the project.

---

## 5. Establish Context with the STAT 380 AI Studio Agent

The STAT 380 AI Studio agent already has access to permanent course-level sources such as:

- STAT 380 coding conventions;
- STAT 380 project workflow;
- the STAT 380 `data.table` guide;
- modeling and validation guidance;
- course philosophy;
- AI working guidance;
- the course textbook.

However, the agent does **not** have direct access to the student's local repository.

At the beginning of a new project, the student should provide the project-specific context that the agent cannot see.

At minimum, provide:

1. the current contents of `project/PROJECT_CONTEXT.md`;
2. the generated data profile or profiles;
3. the assignment instructions or rubric when relevant;
4. any existing code if development has already begun.

The agent should not guess project-specific details that have not been provided.

---

## 6. Use the Agent to Understand the Problem Before Coding

Before asking for a full solution, use the agent to help clarify:

- what the prediction or analysis task is;
- what each dataset represents;
- which variable is the response;
- which variables may be identifiers;
- what the evaluation metric means;
- what output must ultimately be produced;
- what important constraints apply.

The student should be able to explain the project objective before developing a modeling solution.

---

## 7. Plan the Workflow

Before creating many scripts, identify the broad stages required by the project.

A common supervised-learning project might require:

```text
raw data
   ↓
feature construction
   ↓
model-ready data
   ↓
model fitting / validation
   ↓
final model
   ↓
test predictions
   ↓
submission file
```

The exact workflow will vary by project.

The AI agent may help the student decide whether one script is sufficient for a stage or whether the work should be divided into multiple scripts.

Do not create unnecessary complexity merely to match the folder structure.

---

## 8. Develop Feature-Building Code

Feature-building code normally belongs in:

```text
project/src/features/
```

A simple project may use:

```text
project/src/features/build_features.R
```

A more complex project may use multiple scripts such as:

```text
project/src/features/
├── 01_clean_data.R
├── 02_build_features.R
└── 03_prepare_model_data.R
```

Feature-building code should:

- read source or intermediate data using relative paths;
- preserve raw files;
- apply transformations reproducibly;
- apply compatible transformations to training and test data when appropriate;
- write reusable intermediate or processed resources to the appropriate `project/volume/data/` directory.

The AI agent can help author, explain, debug, or revise these scripts.

---

## 9. Develop Modeling Code

Modeling code normally belongs in:

```text
project/src/models/
```

A modeling script may:

- define predictors and response variables;
- create validation or cross-validation structures;
- fit candidate models;
- tune model parameters;
- evaluate performance;
- fit the final model;
- generate predictions;
- create required submission files.

Examples might include:

```text
project/src/models/train_model.R
```

or a more detailed sequence such as:

```text
project/src/models/
├── 01_validate_models.R
├── 02_fit_final_model.R
└── 03_create_submission.R
```

The agent should help students reason about the statistical choices as well as the code required to implement them.

---

## 10. Work Iteratively

Project development is expected to be iterative.

A student may:

- try an approach;
- evaluate it;
- revise features;
- change a model;
- compare alternatives;
- abandon an unsuccessful script;
- return to an earlier idea.

This development history may remain in the repository.

Students do not need to delete every exploratory or unsuccessful script.

The final workflow is declared separately through `project/entry_point.sh`.

---

## 11. Bring Working Context Back to the Agent

As development proceeds, provide the AI Studio agent with the smallest useful additional context needed for the current question.

Examples include:

- the current contents of a script;
- an R error message;
- model output;
- validation results;
- Kaggle leaderboard results;
- a confusing section of a rubric;
- a revised data profile;
- a question about a specific modeling decision.

Do not assume the agent can see changes made locally unless they are pasted or otherwise supplied.

When asking for debugging help, provide the relevant code and the exact error or unexpected result whenever possible.

---

## 12. Prefer Incremental Changes

When a script already exists, the default workflow should be:

1. inspect the current code;
2. identify the specific issue or desired improvement;
3. modify the smallest appropriate portion;
4. rerun the code;
5. evaluate the result.

Avoid replacing an entire working project with a completely different solution unless there is a clear reason.

This makes it easier for the student to understand how the project evolved.

---

## 13. Keep the Final Workflow Explicit

The file:

```text
project/entry_point.sh
```

declares which scripts constitute the final intended project solution and the order in which they should run.

For example:

```bash
#!/bin/bash

Rscript project/src/features/01_clean_data.R
Rscript project/src/features/02_build_features.R
Rscript project/src/models/01_train_model.R
Rscript project/src/models/02_create_submission.R
```

Update `entry_point.sh` whenever the final workflow changes.

Scripts that are not included in `entry_point.sh` may still remain in the repository as evidence of exploration or alternative approaches.

---

## 14. Verify the Project from the Repository Root

The named Git repository root is the expected working directory.

When the project is nearing completion, restart from a clean R session and verify that the declared workflow can be reproduced.

The entry point should normally be run from the repository root:

```bash
bash project/entry_point.sh
```

The final workflow should not depend on:

- objects left in the R workspace;
- manually edited datasets;
- machine-specific absolute paths;
- undocumented interactive steps.

---

## 15. Verify Required Outputs

Before submission, confirm that the project produces the required artifacts.

Examples may include:

- a Kaggle submission CSV;
- processed data;
- saved predictions;
- model objects;
- figures or summaries;
- required repository files.

Check the project rubric and `PROJECT_CONTEXT.md` rather than assuming the required output format.

---

## 16. Verify Understanding

Students may use AI extensively during project development, but they remain responsible for understanding the project they submit.

Before considering the project complete, the student should be able to explain:

- the objective of the project;
- the structure of the supplied data;
- the response variable;
- the major predictors or features used;
- the purpose of each script in `entry_point.sh`;
- how validation was performed;
- what model was fit;
- how predictions were generated;
- where final outputs were written;
- why important modeling choices were made.

The goal of AI-assisted development is to accelerate learning and implementation, not to create a solution the student cannot explain.

---

# Recommended Context Pattern for the AI Studio Agent

The agent operates with three layers of context.

## Permanent Course Context

Already supplied to the agent:

```text
STAT380_CODING_CONVENTIONS.md
STAT380_PROJECT_WORKFLOW.md
STAT380_DATA_TABLE_GUIDE.md
STAT380_MODELING_AND_VALIDATION.md
STAT380_COURSE_PHILOSOPHY.md
STAT380_AI_WORKING_GUIDE.md
ISLR textbook
```

## Project Context

Provided by the student for each project:

```text
PROJECT_CONTEXT.md
data profile(s)
assignment / rubric
```

## Working Context

Provided as needed during development:

```text
current code
error messages
model output
validation results
leaderboard results
specific questions
```

The agent should distinguish among these layers and avoid repeatedly asking for information that has already been supplied in the current conversation.

---

# When the Agent Does Not Have Enough Information

If a student asks a project-specific question and the necessary context has not been supplied, the agent should not invent an answer.

The agent should request the smallest useful missing piece.

Typical requests may include:

> Please paste your `PROJECT_CONTEXT.md`.

> Please provide the generated profile for the dataset you are asking about.

> Please paste the current version of the script.

> Please provide the exact error message.

> Please paste the relevant portion of the assignment rubric.

Once that information is available, the agent should use it as the authoritative context for the current project.

---

# Summary Workflow

```text
START FROM PROJECT TEMPLATE
          │
          ▼
DOWNLOAD PROJECT DATA
          │
          ▼
PLACE DATA IN raw/
          │
          ▼
RUN profile_data.R
          │
          ▼
COMPLETE PROJECT_CONTEXT.md
          │
          ▼
PROVIDE CONTEXT TO AI STUDIO AGENT
          │
          ▼
UNDERSTAND / PLAN
          │
          ▼
BUILD FEATURES
          │
          ▼
FIT / VALIDATE MODELS
          │
          ▼
ITERATE WITH AGENT
          │
          ▼
DECLARE FINAL WORKFLOW IN entry_point.sh
          │
          ▼
RUN FROM CLEAN SESSION
          │
          ▼
VERIFY OUTPUTS AND UNDERSTANDING
          │
          ▼
SUBMIT
```
