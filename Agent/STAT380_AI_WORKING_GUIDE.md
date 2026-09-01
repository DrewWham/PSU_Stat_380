# STAT 380 AI Working Guide

This document describes how students should work with the STAT 380 AI Studio agent during project development.

The agent is intended to function as a course-specific coding and statistical assistant. It can help students plan, write, debug, explain, and improve project work, but it does not replace the student's responsibility to understand the analysis.

The goal is to use AI as a **development partner that accelerates learning**, not as a substitute for learning.

---

## 1. What the Agent Already Knows

The STAT 380 AI Studio agent is built with persistent course-level sources that describe:

- STAT 380 coding conventions;
- the standard project workflow;
- preferred `data.table` practices;
- modeling and validation guidance;
- course philosophy;
- the course textbook.

The agent should therefore already understand the general structure of STAT 380 work.

Students do not need to re-explain these global conventions every time they begin a conversation.

---

## 2. What the Agent Does Not Know Automatically

AI Studio does not have direct access to the student's local computer, R session, or Git repository.

The agent cannot automatically see:

- the current project folder;
- `PROJECT_CONTEXT.md`;
- generated data profiles;
- the assignment rubric;
- the student's current scripts;
- R errors;
- model output;
- Kaggle results.

Students must provide the project-specific context needed for the current question.

---

## 3. Start Each Project by Establishing Context

After creating a new project, the student should:

1. start from the STAT 380 project template;
2. place the supplied data in `project/volume/data/raw/`;
3. run the profiler;
4. complete `project/PROJECT_CONTEXT.md`;
5. open the STAT 380 AI Studio agent;
6. provide the project-specific context to the agent.

A useful initial context package includes:

- the contents of `project/PROJECT_CONTEXT.md`;
- the generated data profile or profiles;
- the assignment instructions or rubric;
- any instructor example relevant to the current unit.

If code development has already begun, also provide the relevant script.

---

## 4. A Good First Message

A strong project-opening message might look like:

> I am starting the current STAT 380 project. Below are my `PROJECT_CONTEXT.md`, data profile, and project rubric. Please use these as the authoritative context for this project. Help me understand what the project is asking me to do and suggest an appropriate first implementation step consistent with the current course unit.

This is better than beginning with:

> Write the solution to Project 3.

The purpose of the context handoff is to help the agent reason from the actual assignment rather than guess.

---

## 5. Use the Smallest Useful Context

Do not paste everything into every message.

Provide the smallest amount of information needed to answer the current question accurately.

Examples:

### For a data question

Provide:

- relevant data profile;
- relevant portion of `PROJECT_CONTEXT.md`.

### For a coding question

Provide:

- the current script or relevant code section;
- the exact desired change.

### For debugging

Provide:

- the code that failed;
- the exact error message;
- enough surrounding code to understand the object being used.

### For modeling questions

Provide:

- project context;
- current rubric or assignment instructions;
- instructor example when it defines the current learning objective;
- current validation or modeling code.

---

## 6. Prefer the Data Profile Over Pasting the Full Dataset

The standard project profiler produces compact descriptions of the raw data.

When asking the agent to reason about a dataset, provide the generated profile first.

The profile may already contain enough information about:

- rows and columns;
- variable names;
- data types;
- missingness;
- unique values;
- categories;
- numeric summaries;
- likely identifiers or free-text variables.

The agent does not usually need every row of the dataset in order to help write or explain code.

If the profile is insufficient, provide the specific additional information needed.

---

## 7. Work Incrementally

AI-assisted development should generally proceed in small, understandable steps.

A good cycle is:

```text
describe the current goal
        ↓
show relevant context/code
        ↓
ask for one change or explanation
        ↓
review the proposed code
        ↓
run it in R
        ↓
inspect the result
        ↓
return with output or error
        ↓
revise
```

This is preferable to asking the agent to replace an entire project at once.

Incremental work makes it easier to:

- understand what changed;
- detect errors;
- preserve working code;
- connect code to course concepts;
- explain the final solution later.

---

## 8. Ask the Agent to Explain Code

Students should not treat generated code as automatically understandable.

Useful follow-up questions include:

> What does each major section of this code do?

> Why are you using `.SDcols` here?

> Which line selects the predictors?

> Which line defines the response variable?

> Where is the validation split created?

> Why is `set.seed()` needed?

> What does this tuning parameter control?

> How does this code produce the final prediction file?

If an explanation is unclear, keep asking until the student can restate the idea independently.

---

## 9. Favor Readable Code

The agent should favor code that a STAT 380 student can read and explain.

Students should prefer:

- descriptive object names;
- explicit relative paths;
- visible predictor lists;
- clear train/test separation;
- multiline `data.table` expressions when helpful;
- explicit intermediate objects for important modeling stages;
- comments that explain decisions.

Do not ask the agent to optimize for the shortest possible code.

Readable code is easier to debug, assess, and understand.

---

## 10. Use AI to Learn `data.table`, Not Avoid It

The agent may help translate a data-wrangling goal into `data.table`.

For example, a student can ask:

> I need to calculate mean sale price by neighborhood. Show me how to do that in readable `data.table` syntax and explain `i`, `j`, and `by`.

The agent should default to the coding conventions used in STAT 380 rather than switching to another framework simply because it is familiar.

---

## 11. Use Instructor Examples to Set the Level of Sophistication

STAT 380 intentionally introduces modeling and validation methods over time.

Students should provide the relevant instructor example or sibling project when it helps establish what is currently being taught.

The agent should use that example to infer:

- which methods are expected;
- what validation strategy is appropriate;
- what level of complexity is intended;
- what terminology the instructor is using.

Do not use AI to jump directly to a later-course method simply because it may produce a higher score.

---

## 12. Ask for Alternatives, Not Just Answers

AI is especially useful for exploring choices.

Students might ask:

> What are two reasonable ways to construct this feature?

> What are the tradeoffs between these two validation strategies?

> Why might ridge perform differently from lasso here?

> What would you inspect before deciding whether this categorical variable should be encoded differently?

> What are likely reasons my validation score improved but Kaggle performance declined?

The goal is to develop statistical judgment, not simply receive executable syntax.

---

## 13. Debug with Evidence

When code fails, provide the exact evidence.

A useful debugging message includes:

1. what the student expected;
2. what actually happened;
3. the relevant code;
4. the exact error message or output.

For example:

> I expected `model_data` to have 25 columns, but it has 41. Here is the feature script and the output of `names(model_data)`. Help me identify where the extra columns are entering.

This is more useful than:

> My code does not work.

---

## 14. Verify AI Suggestions in R

AI-generated code should always be tested.

The agent can make mistakes involving:

- object names;
- column names;
- package syntax;
- assumptions about data types;
- return-object structure;
- model arguments;
- path names;
- statistical interpretation.

Run the code and inspect the result.

Do not assume correctness because the explanation sounds confident.

---

## 15. Keep the Agent Updated When the Project Changes

The agent only knows the project context that has been supplied in the current conversation.

If the student:

- changes the target;
- revises a feature script;
- changes the validation approach;
- adds a new dataset;
- updates `PROJECT_CONTEXT.md`;
- changes the final workflow;

provide the relevant updated information.

Do not assume the agent can see local changes automatically.

---

## 16. Maintain the Repository While Working with AI

AI-assisted work should still follow the project structure.

Code belongs under:

```text
project/src/
```

Generated data belong under:

```text
project/volume/
```

Raw data remain unchanged.

The final project workflow should remain declared in:

```text
project/entry_point.sh
```

If AI-assisted changes add, remove, or reorder scripts in the final solution, update `entry_point.sh`.

---

## 17. Preserve Exploratory Work

Students may keep scripts representing:

- unsuccessful attempts;
- alternative features;
- alternative models;
- intermediate experiments.

AI should not automatically delete these files merely because they are no longer part of the final workflow.

The final solution is identified through `project/entry_point.sh`.

This allows the repository to preserve the development process while remaining reproducible.

---

## 18. Ask the Agent to Review, Not Just Generate

The agent can also inspect student-written code.

Useful requests include:

> Review this feature script for path problems, leakage, and reproducibility.

> Check whether this code follows STAT 380 project conventions.

> Identify where this script depends on objects that were created interactively rather than inside the script.

> Compare this code with the project rubric and tell me which requirements appear satisfied and which need attention.

Students should still independently verify the agent's findings.

---

## 19. Use AI Before Submission as a Comprehension Check

Before submitting a project, students can ask the agent to help test their understanding.

For example:

> Ask me five questions about my submitted code that I should be able to answer without running it.

or:

> Based on this script, ask me where the predictors are selected, where the model is fit, how validation works, and where test predictions are created.

This is a useful way to prepare for the Project Understanding Activity.

The student should answer before asking the agent to reveal explanations.

---

## 20. Do Not Use AI During Restricted Assessments

AI may be used extensively during project development unless the instructor explicitly states otherwise.

AI may not be used during assessments where outside assistance is prohibited, including Project Understanding Activities, quizzes, or exams when specified by the instructor.

Follow the instructions for the assessment.

---

## 21. The Student Owns the Final Decision

The agent may recommend:

- a transformation;
- a model;
- a tuning value;
- a validation strategy;
- a coding pattern.

The student should decide whether the recommendation makes sense in the context of:

- the assignment;
- the rubric;
- the instructor example;
- the data;
- the evaluation metric;
- the current course unit.

AI output is advice, not authority.

---

## 22. Do Not Hide Confusion

If generated code contains syntax or concepts the student does not understand, that is a signal to stop and ask.

Useful responses include:

> I do not understand why this works. Explain it without changing the code yet.

> Rewrite this using a more readable approach.

> I have not learned this method yet. Can we solve the same problem using the approach from the instructor example?

> Which parts of this code are beyond what has been introduced in the current unit?

The agent should adapt to the student's current level rather than forcing unnecessary sophistication.

---

## 23. A Recommended Working Pattern

A typical AI-assisted project session might look like:

```text
STUDENT
Provides PROJECT_CONTEXT.md
        ↓
STUDENT
Provides data profile
        ↓
STUDENT
Provides rubric / instructor example
        ↓
AGENT + STUDENT
Clarify the learning objective
        ↓
AGENT + STUDENT
Plan the next coding step
        ↓
AGENT
Suggests readable code
        ↓
STUDENT
Runs code in R
        ↓
STUDENT
Returns result / error
        ↓
AGENT + STUDENT
Interpret and revise
        ↓
REPEAT
```

The student remains actively involved throughout the process.

---

## 24. Before Considering a Project Complete

The student should be able to explain:

- the project objective;
- the role of each input dataset;
- the response or target;
- the important features;
- the validation strategy;
- the model used;
- the evaluation metric;
- the purpose of each script in `entry_point.sh`;
- how predictions are generated;
- where outputs are written;
- why the final approach was chosen.

If the student cannot explain one of these, the agent should help close that understanding gap before focusing on additional complexity.

---

# Default Principle

The STAT 380 AI Studio agent is a powerful tool for project development.

Use it to:

```text
reduce friction
        +
increase experimentation
        +
improve debugging
        +
deepen explanation
        +
support statistical reasoning
```

Do not use it to create a project that the student cannot understand.

> **The best AI-assisted solution is not merely code that works. It is code that works and that the student can explain.**
