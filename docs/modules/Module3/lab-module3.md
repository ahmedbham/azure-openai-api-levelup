---
title: Lab
parent:  Module 3 - Semantic Kernel
has_children: false
nav_order: 2
---

# Module 3: Lab - Book Creator application

#### The Book creator sample allows you to enter in a topic then the Planner creates a plan for the functions to run based on the ask. You can see the plan along with the results. The Writer Skill functions are chained together based on the user asks.

note: it is recommended that this lab be done via GitHub codepaces

prerequisites
- OpenAI or AzureOpenAI key


## Running the sample

1. Fork or Clone the semantic kernel repo

   `git clone https://github.com/microsoft/semantic-kernel.git`

2. Start the KernelHttpServer, this is the backend API server used by the front end React app and is the intermediary between the front end client application and OpenAI/AzureOpenAI

   `cd samples/dotnet/KernelHttpServer`

    **Run** `func start --csharp` from the command line. This will run the service API locally at `http://localhost:7071`.

3. In another terminal window, start the BookCreator web application

   `cd samples/apps/book-creator-webapp-react/`

4. Rename the `.env.example` file to `.env`.

5. Start the book creator app by running the following commands

   - Install all dependencies by running `yarn install`
   - Start the application by running `yarn start`

6. A browser will automatically open, otherwise you can navigate to `http://localhost:3000` to use the sample.

7. On the application page, enter your OpenAI or AzureOpenAI key and also a value for the model ID as shown below, you may use the default text-davinci-003 and click save

   ![Semantic Kernel Use cases](../../assets/images/module3/sk-bookcstart.png)

9. Follow the application prompts to enter a book idea and click getIdeas button to see response.

10. Select an idea option and click on 'create book' button to see the created book. Note, you need to additionally click on the play button as shown below on the next screen to get the book contents.

    ![Semantic Kernel Use cases](../../assets/images/module3/sk-bcplay.png)
