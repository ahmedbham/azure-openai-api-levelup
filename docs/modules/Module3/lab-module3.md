---
title: Lab
parent:  Module 3 - Semantic Kernel
has_children: false
nav_order: 2
---

# Module 3: Lab - Book Creator application
 
 The Book creator sample application shows how `planner`, `skills` and `memories` are used to enrich content for a specific use case and allows you to enter in a children's book topic. Then the `Planner` creates a plan for the functions (skills) to run based on the Ask. You can see the execution plan along with the results. The `Writer` Skill functions are chained together based on the user ask.

**Note**: It is recommended that this lab exercise be done via GitHub Codespaces

### Prerequisites

- An Azure OpenAI API key

## Running the sample

**Note**: to run the sample in VS Code Desktop using Dev Containers from Github Codespaces:
  Click hamburger menu on the left side of the VS Code window in Codespaces and select **Open in VS Code Desktop**

1. Clone the `semantic kernel` repo

   ```bash
   git clone https://github.com/microsoft/semantic-kernel.git
   ```

2. Start the `KernelHttpServer`. This is the backend API server used by the front end React app and is the intermediary between the front end client application and AzureOpenAI

   ```bash 
   cd semantic-kernel/samples/dotnet/KernelHttpServer
   ```

3. **Run**

   ```bash
   func start --csharp
   ```

   This will run the service API locally at `http://localhost:7071`.

4. In another terminal window, start the `BookCreator` web application

   ```bash
   cd semantic-kernel/samples/apps/book-creator-webapp-react/
   ```

5. Rename the `semantic-kernel/samples/apps/book-creator-webapp-react/.env.example` file to `semantic-kernel/samples/apps/book-creator-webapp-react/.env`.

6. Start the book creator app by running the following commands

   ```bash
   yarn install
   yarn start
   ```

7. A browser will automatically open, otherwise you can navigate to `http://localhost:3000` to access the application.

8. On the application main page, enter your AzureOpenAI key and also a value for the model ID as shown below, you may use the default **text-davinci-003** and click **Save** button

   ![Semantic Kernel Use cases](../../assets/images/module3/sk-bookcstart.png)

9. Follow the application prompts to enter a book idea and click **get Ideas** button to see some sample suggestions.

10. Select an idea option and click on the **create book** button to see the newly created book. Note: you need to additionally click on the play button as shown below on the next screen to get the book contents.

    ![Semantic Kernel Use cases](../../assets/images/module3/sk-bcplay.png)
