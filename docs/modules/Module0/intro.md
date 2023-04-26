**What is Azure OpenAI Service?**

Azure OpenAI Service is a cloud-based service that provides access to
the OpenAI API. You can use the OpenAI API to perform the following
tasks:

-   Language Understanding

-   Text Summarization

-   Semantic Search

-   Conversation AI

-   Code Generation

OpenAI is a powerful Language Generative model that predicts the next
token to generate text output based on the input instruction from the
user. Azure OpenAI is the model pretrained and hosted in Azure for
easier deployment for the customer projects.

To learn more about Azure OpenAI Service, you can:

-   Check out the [Azure OpenAI Service
    documentation](https://docs.microsoft.com/en-us/azure/openai/).

## Concepts:
The user 'Prompt' gives text instructions with the appropriate context.
The more detailed it is with possible examples, it would help the model
to arrive to the right context and generate the result set 'Completion'
that is presented to the user.

You can train the model with one or few-shot examples or with
interactions. The model can be fine-tuned with a few parameters to
customize it to the specific need. The model can be tuned to be
deterministic/probabilistic or instructed to continue with the results
based on these set parameter values.

## Azure OpenAI Service Models:

-   GPT-3 is the first offering with the 4 models Ada, Babbage, Curie
    and Davinci with the increasing inferencing capabilities, but would
    consume more time for presenting the results. The GPT Codex models
    supports Co-pilot.

-   GPT-35-Turbo is the ChatGPT model option with improved accuracy for
    a conversational model.

-   GPT-4 is the preview version that allows for a larger token size
    prompts and has security built-in. You can request using this
    [Access Request
    Form](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xURjE4QlhVUERGQ1NXOTlNT0w1NldTWjJCMSQlQCN0PWcu)

## Applications and Use cases:

The language generation from the GPT is based on the semantics of the
Prompt that help it to the inference Completion in the below scenarios
with some examples:

-   Writing Assistance:

    -   Government agency using Azure OpenAI Service to extract and
        summarize key information from their extensive library of rural
        development reports.

    -   Financial services using Azure OpenAI Service to summarize
        financial reporting for peer risk analysis and customer
        conversation summarization.

-   Code Generation:

    -   Aircraft company using to convert natural language to SQL for
        aircraft telemetry data.

    -   Consulting service using Azure OpenAI Service to convert natural
        language to query propriety data models.

-   Reasoning over data

    -   Financial services firm using Azure OpenAI Service to improve
        search capabilities and the conversational quality of a
        customer's Bot experience.

    -   Insurance companies extract information from volumes of
        unstructured data to automate claim handling processes.

-   Summarization:

    -   International insurance company using Azure OpenAI Service to
        provide summaries of call center customer support
        conversation-logs.

    -   Global bank uses Azure OpenAI Service to summarize financial
        reporting and analyst articles .

## Prompt Engineering:

The model is only as effective as the Prompts sent as input. And this
also trains the models to arrive to a customized model with appropriate
inference context. Here are a few techniques that can support a better
model performance:

1.  Structure the input to instruct the model in a step-by-step process
    to make it understand the question and suggest it arrive to the
    inference.

2.  Prompt Chaining helps to elicit more reliable answers and fine tune
    it with thousands of Prompts to fine tune it.

3.  The models are limited by the Prompt token size for the deployment
    type chosen. Long text beyond the token limit is broken into Chunks
    and processed.

4.  Leverage One-Shot/Few-Shot reasoning to be specific about what is
    the expected result set. The model can learn using these scenarios
    presented in the Prompt, and you are explicitly telling the mode how
    to think by prompting how it should reason for the similar problem.

5.  This technique called Chain-of-Thought, is a super powerful
    technique, not only can it be used to provide model explainability
    (where sometimes GPT-3 is seen as a blackbox) but it can help the
    model reason and arrive at a desired output by simply just telling
    the model to think step by step.

6.  One interesting trick is to have the model decompose the task into
    smaller tasks and figure it out on its own. This allows the model to
    reason along the way and can lead to much better results. The
    technique is called selection-inference prompting.

## Responsible AI (RAI):

The AI models designed for a specific purpose needs to be perceived to
be safe, trustworthy, and ethical. Responsible AI can help proactively
guide these decisions toward more beneficial and equitable outcomes.

-   Ensure the model is compliant to the principles of RAI at different
    layers of the model deployed with appropriate checks and assessments
    at Fine Tuning , at Prompts to generated results , monitoring the
    response and the product performance against the expected promises.

-   Content Filtering, Feedback channel, Transparency in the product are
    a few ways to ensure application is Fair , Reliable , Transparent
    and Secure.

## How do I get started with building applications using Azure OpenAI Service?

The best way to get started with building applications using Azure
OpenAI Service is to follow the tutorials in this repository.
