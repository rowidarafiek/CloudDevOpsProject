# ArgoCD Continuous Deployment

GitOps-based continuous deployment for CloudDevOps project.

## 📋 Overview

ArgoCD automatically:

- Monitors GitHub repository
- Syncs Kubernetes manifests
- Deploys applications
- Maintains desired state
- Provides rollback capability

## 🏗️ Architecture
Git Repository (Source of Truth)
↓
ArgoCD (Monitors changes every 3 min)
↓
Kubernetes Cluster (Syncs state)
↓
Application Deployed


## 📁 Files
argocd/
├── README.md
└── application.yaml    # Application definition
