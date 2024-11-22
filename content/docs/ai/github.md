---
title: Github
date: 2024-11-22T19:35:40+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 1
---

{{< button/docs text="Framework for building LLM applications"  link="" >}}

{{< card/github-container >}}
  {{<
    card/github 
    repo="deepset-ai/haystack"
    description="AI orchestration framework to build customizable, production-ready LLM applications. Connect components (models, vector DBs, file converters) to pipelines or agents that can interact with your data. With advanced retrieval methods, it's best suited for building RAG, question answering, semantic search or conversational agent chatbots."
    link="https://github.com/deepset-ai/haystack"
    language="python"
    color="#2b679a"
    stars="17.8k" 
  >}}
  {{<
    card/github 
    repo="RasaHQ/rasa"
    description="Open source machine learning framework to automate text- and voice-based conversations: NLU, dialogue management, connect to Slack, Facebook, and more - Create chatbots and voice assistants"
    link="https://github.com/RasaHQ/rasa"
    language="python"
    color="#2b679a"
    stars="19k" 
  >}}
  {{<
    card/github 
    repo="huggingface/transformers"
    description="Transformers: State-of-the-art Machine Learning for Pytorch, TensorFlow, and JAX."
    link="https://github.com/streamlit/streamlit"
    language="python"
    color="#2b679a"
    stars="135k" 
  >}}
  {{<
    card/github 
    repo="streamlit/streamlit"
    description="Streamlit — A faster way to build and share data apps."
    link="https://github.com/streamlit/streamlit"
    language="python"
    color="#2b679a"
    stars="35.8k" 
  >}}
  {{<
    card/github 
    repo="run-llama/llama_index"
    description="LlamaIndex is a data framework for your LLM applications"
    link="https://github.com/streamlit/streamlit"
    language="python"
    color="#2b679a"
    stars="36.9k" 
  >}}
  {{<
    card/github 
    repo="chroma-core/chroma"
    description="The AI-native open-source embedding database"
    link="https://github.com/chroma-core/chroma"
    language="python"
    color="#2b679a"
    stars="15.5k" 
  >}}
{{< /card/github-container >}}


## Hugging Face Transformers
+ **用途**：提供多种预训练的语言模型，支持文本生成、分类、问答等任务。
+ **特点**：
  + 支持多种模型（如 BERT、GPT-2、T5 等）。
  + 提供简单的 API，易于使用和集成。

## LangChain
+ **用途**：用于构建基于语言模型的应用程序，支持链式调用和上下文管理。
+ **特点**：
  + 模块化设计，支持多种语言模型的集成。
  + 适合构建对话系统、问答系统等。

## Haystack
+ **用途**：用于构建基于 LLM 的问答系统和信息检索应用。
+ **特点**：
  + 支持多种后端（如 Elasticsearch、FAISS）。
  + 提供文档检索、问答和对话功能。


## Rasa
+ **用途**：用于构建对话式 AI 和聊天机器人。
+ **特点**：
  + 提供自然语言理解（NLU）和对话管理功能。
  + 可以与 LLM 集成以增强对话能力。


## LlamaIndex（原名 GPT Index）
+ **用途**：用于构建与 LLM 交互的索引和数据结构。
+ **特点**：
  + 允许用户将外部数据与 LLM 结合，增强模型的知识和上下文能力。

## Chroma
+ **用途**：用于构建和管理向量数据库，支持 LLM 的检索和存储。
+ **特点**：
  + 提供高效的向量存储和检索功能，适合与 LLM 结合使用。


## DeepSpeed
+ **用途**：用于训练和推理大规模语言模型。
+ **特点**：
  + 提供高效的分布式训练和推理能力，适合大规模模型的开发。

## Fairseq
+ **用途**：由 Facebook AI Research 开发的序列到序列学习框架。
+ **特点**：
  + 支持多种 NLP 任务，包括翻译和文本生成。
  + 提供多种预训练模型和训练工具。

## Triton
+ **用途**：用于加速深度学习模型的推理。
+ **特点**：
  + 提供高效的 GPU 加速，适合大规模 LLM 的推理。