# Understanding GenStage back-pressure mechanism

## Introduction

Back-pressure is a technique utilized to prevent an application or a piece of software of using more resources than there are available on a given infrastructure.

[GenStage](https://hexdocs.pm/gen_stage/GenStage.html) is an Elixir library to build complex processes divided by steps (or stages) that share data between them. This is the core behaviour used on [Broadway](https://hexdocs.pm/broadway/introduction.html), a multi-stage data ingestion backed on message queue systems such as Kafka, RabbitMQ and others.

## The problem

Suppose you've built a news sharing system which is composed of three main components:
- **Data ingestor (A):** constantly searches and downloads tweets that contains hashtags of interest, such as #computerscience, #architecture and #programming.
- **Republisher (B):** takes a tweet content, renders it on several different formats (HTML, Markdown, PDF and so on) and then publishes on different platforms.
- **Reporter (C):** writes to database the timestamps of each publishing and also exports metrics to be analyzed on the future.

![System configuration](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/kezoyjiyhsq0bigpq88q.png)

The process being executed on component A is simple and takes only a single request to be done: a GET on Twitter's API. For this action we will account an imaginary measurement of **1N** amount of energy to get done.

Now that a tweet content is retrieved and delivered to component B, a more complex process starts: it is required to transform the data acquired on several different formats and then make several other requests to external services (which may or not fail, timeout or take several more amount of time than usual). For this step then we will account **10N** amount of energy taken.

Component C executes a simpler process as well since it only does a write operation on database and then create telemetry data that will be polled later. That's **2N** amount of energy on our example.

As you can imagine, this scenario is problematic because component A generates input for component B on a speed ratio that it can't absorb, and that generates a overflow on B's execution queue.

![System overflow](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/m65fd4xz2bis7yht4xz2.png)

## The solution

GenStage strategy to apply back-pressure is to invert the flow direction from the producer to the consumer and so consumers now control the velocity and amount of data transmitted.

![Back-pressured system](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/91fu1mipwq3nq5282ng1.png)

Component C starts with its execution queue empty and then asks Component B (which is a consumer-producer) to produce a piece of data.

Component B which also has it's execution queue empty now asks Component A to produce a piece of data and only then the Tweeter API is called!

The amount of data produced is back-pressured so no queues gets overflowed and that's how you have a healthy workflow on Elixir using GenStages.
