# Jenkins CI Pipeline

Continuous Integration configuration for CloudDevOps project.

## 📋 Overview

Jenkins pipeline that:

1. Builds Docker images
2. Scans for vulnerabilities (Trivy)
3. Pushes to DockerHub
4. Updates Kubernetes manifests
5. Commits changes to Git

Uses shared library for reusable functions.

## 🏗️ Architecture
GitHub Webhook → Jenkins
↓
Build Image → Scan → Push → Update Manifests → Commit
↓
DockerHub + GitHub (updated manifests)
↓
ArgoCD Auto-Sync

## 📁 Structure
jenkins/
├── README.md
└── shared-library/
└── vars/
├── buildDockerImage.groovy
├── scanImage.groovy
├── pushDockerImage.groovy
├── deleteDockerImage.groovy
├── updateManifests.groovy
└── pushManifests.groovy

## 🚀 Quick Start

### Prerequisites

- Jenkins 2.4+
- Docker plugin
- Git plugin
- Pipeline plugin
- Credentials configured


