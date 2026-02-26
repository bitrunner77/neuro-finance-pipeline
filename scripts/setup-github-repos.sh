#!/bin/bash
# GitHub Project Setup Script
# Run this after authenticating with: gh auth login

USERNAME="BitRunner77"

# Create repos for each project
echo "Creating GitHub repositories for BitRunner77..."

# 1. YouTube Storytelling Channel
gh repo create "$USERNAME/youtube-storytelling-ai" \
  --description "AI-powered faceless YouTube storytelling channel" \
  --public \
  --add-readme

# 2. Micro-SaaS Projects
gh repo create "$USERNAME/micro-saas-lab" \
  --description "Collection of micro-SaaS experiments" \
  --public \
  --add-readme

# 3. Training Bot Service
gh repo create "$USERNAME/training-bot-service" \
  --description "AI training bot as a service" \
  --public \
  --add-readme

# 4. Pain Points Research
gh repo create "$USERNAME/pain-points-research" \
  --description "Research on real pain points and business opportunities" \
  --public \
  --add-readme

echo "Done! Repositories created."
echo "Next: cd into each project and push code."
