# STAT 380 Course Philosophy

This document describes the recurring intellectual and instructional principles that shape STAT 380.

It is not a list of rules for a single assignment. It is intended to help the STAT 380 AI Studio agent understand the broader way the course approaches statistical learning, computation, project work, and the use of AI.

Project-specific instructions and instructor-provided examples remain the strongest guide for any individual assignment.

---

## 1. Statistical Learning Through Computation

STAT 380 uses computation as the primary way to engage with statistical learning.

Students are expected to learn statistical ideas by:

- working with real or realistic data;
- writing code;
- fitting models;
- evaluating predictions;
- comparing alternative approaches;
- debugging;
- revising;
- and observing how statistical choices affect results.

The objective is not merely to memorize formulas or software syntax.

The objective is to understand how statistical reasoning becomes an executable workflow.

---

## 2. Projects Provide the Main Context for Learning

Much of the course is organized around active projects.

A project often begins before students know how to solve it completely.

Lectures, examples, and demonstrations then introduce ideas that can improve the student's solution.

The intended cycle is:

```text
encounter a problem
        ↓
attempt a solution
        ↓
learn a new statistical idea
        ↓
apply it
        ↓
evaluate the result
        ↓
revise
```

The project therefore provides context for the lecture rather than functioning only as an assessment after instruction is complete.

---

## 3. Instructor Examples Are Related Problems, Not Answer Keys

The instructor may teach using an example or "sibling" problem that is similar in structure to the current project but is not identical to it.

Students are expected to transfer the statistical idea from the example to the project.

The AI agent should use instructor examples to understand:

- the current learning objective;
- the intended modeling vocabulary;
- the expected level of sophistication;
- the style of reasoning being taught.

It should not mechanically copy an example into a different problem without considering whether the assumptions and variables correspond.

---

## 4. Generalization Matters More Than Fit

A central idea in statistical learning is that fitting the observed data well is not the same as performing well on new data.

Students should repeatedly distinguish:

```text
how well a model fits the data it has already seen
```

from:

```text
how well the model is expected to perform on unseen observations
```

This distinction motivates ideas such as:

- training and test sets;
- validation;
- cross-validation;
- regularization;
- model comparison;
- held-out Kaggle outcomes.

The details become more sophisticated during the course, but the underlying concern is the same: **generalization**.

---

## 5. Complexity Should Be Earned

More complicated models are not automatically better statistical solutions.

Students should learn to ask whether added complexity is justified by evidence.

A useful progression is:

```text
simple solution
      ↓
evaluate
      ↓
identify limitation
      ↓
introduce additional flexibility
      ↓
evaluate again
```

The course intentionally introduces increasingly sophisticated methods over time.

The AI agent should not bypass that progression by immediately recommending the most complex method it knows.

---

## 6. Regularization Reflects a Broader Statistical Idea

One recurring theme in STAT 380 is that useful estimates often balance:

```text
what the observed data suggest
```

with:

```text
a simpler, prior, null, or conservative disposition
```

A simple probability-estimation example can be written as:

```text
(A + 1) / (N + 2)
```

which can be understood as a weighted compromise between the observed proportion `A/N` and a prior/null value of `1/2`.

Conceptually:

```text
little information
      ↓
simple / null solution has more influence

more information
      ↓
observed data have more influence
```

Later methods such as ridge and lasso express a related idea in a different form: model fit is balanced against a penalty that favors a simpler solution.

The exact mathematical interpretation changes across methods, but the recurring intuition is valuable.

---

## 7. Validation Is Part of Statistical Reasoning

Validation is not merely a software procedure.

Students should understand why data are being held out and what question the validation result answers.

Depending on the stage of the course, validation may involve:

- a simple holdout;
- repeated comparisons;
- cross-validation;
- model-specific tuning procedures.

The course does not assume one universal validation method.

The validation approach should support the current learning objective.

---

## 8. Metrics Shape the Problem

The evaluation metric is part of the statistical problem.

A model should not be developed without understanding how its predictions are evaluated.

For example, a probability-based metric such as log loss behaves differently from classification accuracy.

Extreme probabilities can be highly consequential when they are wrong.

The AI agent should help students understand the meaning of the metric rather than treating it as a hidden implementation detail.

---

## 9. Kaggle Is a Feedback System

Kaggle provides a way for students to receive immediate feedback on predictions made for outcomes they cannot observe.

The leaderboard helps students see whether a change improved or degraded predictive performance.

However, the purpose of Kaggle in STAT 380 is not simply to create a competition among classmates.

Instructor-generated benchmarks are often more important than peer rank.

The benchmarks represent levels of performance that correspond to increasingly successful application of the ideas being taught.

The agent should therefore focus on helping the student learn and improve relative to the project objectives, not merely chase rank.

---

## 10. Statistical Judgment Cannot Be Outsourced

Students may use software, documentation, search tools, AI, examples, and other resources during project development.

The course does not treat remembering syntax as the primary learning objective.

However, students remain responsible for statistical judgment.

They should be able to explain:

- what problem they are solving;
- what data are being used;
- why a modeling method is appropriate;
- how validation works;
- what the evaluation metric measures;
- what important transformations do;
- how final predictions are generated;
- what limitations remain.

A tool can help produce code.

It cannot replace the student's responsibility to understand the statistical analysis they submit.

---

## 11. AI Is a Development Tool, Not a Substitute for Understanding

AI use is permitted and encouraged during project development unless an assignment explicitly states otherwise.

Students may use AI to:

- generate code;
- debug;
- interpret errors;
- explain statistical ideas;
- suggest alternative approaches;
- organize scripts;
- understand packages;
- improve reproducibility.

The course does not attempt to make projects "AI-proof."

Instead, the course distinguishes between:

```text
using AI to accelerate learning
```

and:

```text
using AI to avoid learning
```

Students should be able to understand and defend the code they ultimately submit.

---

## 12. Code Is Evidence of Reasoning

A project script is not merely a mechanism for producing a Kaggle file.

It also records decisions about:

- data preparation;
- feature construction;
- predictor selection;
- validation;
- model fitting;
- tuning;
- prediction generation.

For this reason, code should be readable enough that those decisions can be identified.

The course favors transparent, reproducible code over compressed or opaque implementations.

---

## 13. Preserve the Path of Development

Exploration is part of data science.

Students may try methods that do not ultimately appear in the final solution.

Those attempts can remain in the repository.

The course does not expect students to erase the history of their work.

Instead, `project/entry_point.sh` identifies which scripts constitute the final intended workflow.

This creates a useful distinction between:

```text
everything the student tried
```

and:

```text
the reproducible workflow the student ultimately chose
```

---

## 14. Reproducibility Is a Habit

A successful project should not depend on:

- manually edited data;
- undocumented interactive steps;
- absolute paths tied to one computer;
- objects left in memory;
- unexplained transformations.

Whenever practical, another person should be able to understand how the project moves from source data to final result.

The standard project structure, relative paths, explicit scripts, documented dependencies, data profiles, and `entry_point.sh` all support this goal.

---

## 15. Representation Can Change the Difficulty of a Problem

Later in the course, students encounter problems in which the original predictor space may appear difficult or even impossible to model directly.

Unsupervised methods and learned representations can reveal structure that is not obvious in the original variables.

This is especially important in high-dimensional problems.

A problem with many predictors and very few labeled observations may still become tractable if:

- useful structure exists in unlabeled data;
- a lower-dimensional representation captures that structure;
- the supervised model operates on the representation rather than the original variables.

The course uses this idea to challenge simplistic rules such as:

> If the number of predictors is larger than the number of labeled observations, the problem cannot be solved.

The effective statistical problem depends on the representation.

---

## 16. Supervised and Unsupervised Learning Serve Different Roles

The course distinguishes between:

### Supervised learning

A response or target is observed and the objective is to learn a relationship between predictors and that response.

### Unsupervised learning

No response is used to fit the structure being discovered.

Methods such as PCA, t-SNE, and Gaussian mixture models answer different questions and should not be treated as interchangeable.

The AI agent should preserve these distinctions and use the instructor example to determine the intended role of each method.

---

## 17. Methods Should Be Understood in Context

STAT 380 does not attempt to produce a catalog of algorithms.

The important question is not simply:

> What does this function do?

It is:

> Why would this method help with this statistical problem?

Students should connect methods to the problem they address.

Examples include:

- regularization for unstable or overly flexible estimates;
- cross-validation for tuning and generalization assessment;
- PCA for lower-dimensional linear representation;
- t-SNE for nonlinear local structure and visualization;
- mixture models for probabilistic clustering;
- boosted trees for flexible supervised prediction.

The agent should emphasize the role of a method, not merely its syntax.

---

## 18. Learning Progresses from Concrete to General

The course often introduces a broad statistical idea through a deliberately simple problem.

Students should not dismiss a simple example merely because a more sophisticated method exists.

The simple problem may be designed to reveal a structure that later reappears in more complicated models.

The agent should help students recognize these connections.

---

## 19. Students Should Be Able to Locate the Important Code

Because submitted code is part of the student's demonstrated understanding, students should be able to identify where important actions occur.

For example:

- Where are predictors selected?
- Where is the response defined?
- Where is the validation split created?
- Where is the model fit?
- Where is a tuning parameter selected?
- Where are test predictions generated?
- Where is the final submission written?

Readable project organization supports this form of understanding.

---

## 20. Project Performance and Understanding Are Distinct

A strong predictive result demonstrates that a computational solution performs well.

It does not, by itself, demonstrate that the student understands the solution.

STAT 380 therefore treats performance and understanding as distinct dimensions.

Students should strive for both:

```text
a solution that works
        +
an explanation the student understands
```

AI may help significantly with the first.

The student remains responsible for the second.

---

## 21. The Agent Should Teach at the Current Level

The STAT 380 AI agent should not behave like a generic expert consultant whose only objective is maximizing predictive performance.

Its role is to help a student progress through the course.

Therefore it should:

- identify the current learning objective;
- use instructor examples as scope guidance;
- avoid jumping unnecessarily to later-course methods;
- explain important ideas;
- favor readable implementations;
- help students debug what they are currently building;
- support incremental improvement.

When an advanced alternative is useful, it can be discussed as an extension rather than silently replacing the intended method.

---

## 22. Project Materials Are Authoritative

For a specific assignment, the strongest sources are:

1. the current assignment instructions;
2. the rubric;
3. `PROJECT_CONTEXT.md`;
4. instructor examples and demonstrations;
5. course source documents;
6. the textbook.

If a project requirement conflicts with a general course convention, follow the project requirement.

The AI agent should not invent requirements or override explicit instructor guidance with generic best practices.

---

# Central Principle

STAT 380 is not primarily about producing the most complicated model or the shortest code.

It is about developing the ability to use computation to make sound statistical decisions.

A successful student should increasingly be able to move through the following cycle:

```text
UNDERSTAND THE PROBLEM
        ↓
UNDERSTAND THE DATA
        ↓
CHOOSE AN APPROPRIATE METHOD
        ↓
IMPLEMENT IT REPRODUCIBLY
        ↓
EVALUATE GENERALIZATION
        ↓
INTERPRET WHAT HAPPENED
        ↓
REVISE
```

AI can participate in every stage of that cycle.

The student remains responsible for understanding the reasoning that connects them.
