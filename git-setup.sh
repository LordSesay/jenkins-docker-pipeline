#!/bin/bash
echo "Setting up Git repository..."

git init
git add .
git commit -m "Initial commit: Jenkins pipeline with Docker and ECR"

echo
echo "Next steps:"
echo "1. Create repository on GitHub.com named 'jenkins-docker-pipeline'"
echo "2. Run these commands:"
echo "   git remote add origin https://github.com/YOUR-USERNAME/jenkins-docker-pipeline.git"
echo "   git branch -M main"
echo "   git push -u origin main"