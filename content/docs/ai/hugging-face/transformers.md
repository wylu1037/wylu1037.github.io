---
title: Transformers
date: 2024-11-25T19:27:12+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

Sentiment Analysis with pipeline
```python
from transformers import pipeline

classifier = pipeline(task="sentiment-analysis")

result = classifier("I love using transformers!")
print(result) # [{'label': 'POSITIVE', 'score': 0.9998760223388672}]
```

or Specific model
```python
classifier = pipeline(task="sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")

result = classifier("I love using transformers!")
print(result) # [{'label': 'POSITIVE', 'score': 0.9998760223388672}]
```

Other tasks
- [ ] Text Generation
- [ ] Question Answering
- [ ] Summarization
- [ ] Translation
- [ ] Zero-Shot Classification
- [ ] Token Classification
- [ ] Conversational
- [ ] Feature Extraction
- [ ] Fill-Mask
- [ ] Image Classification
- [ ] Image Segmentation
- [ ] Object Detection
- [ ] Table Question Answering
- [ ] Text2Text Generation


