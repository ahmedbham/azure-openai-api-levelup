---
title: Book Creator detailed flow
parent:  Module 3 - Semantic Kernel
has_children: false
nav_order: 3
---

## Module 3: Book Creator application detailed flow

The following sequence diagram illustrates the interactions of the Book creator Client app and the Semantic Kernel API exposed via the dotnet C# function.


The function API exposes only 2 endpoints

- /skills/{skillName}/invoke/{functionName}

- /planner/execute/{maxSteps}


  ![Semantic Kernel Use cases](../../assets/images/module3/book-creator-sequence.png)

1. The childrensBookSkill is a predefined skill that with a templated prompt that can be found in the samples/skills folder, a skill may have one to many sub-skills or functions.
2. The planner skill is also a specialized skill that can leverage additional skills, embeddings and connectors.
3. The planner execute API used the templated values of the previous steps/instructions from the planner to fulfill the user's Ask.
