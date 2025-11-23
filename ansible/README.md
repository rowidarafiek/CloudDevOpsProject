# Ansible Configuration Management

Automated server configuration for CloudDevOps project.

## 📋 Overview

This Ansible configuration:

- Installs system packages
- Configures Docker
- Installs Java 17
- Sets up Jenkins
- Configures kubectl and Minikube
- Uses role-based organization
- Implements dynamic inventory

## 🏗️ Structure
ansible/
├── ansible.cfg          # Ansible configuration
├── playbook.yml         # Main playbook
├── inventory/
│   ├── aws_ec2.yml     # Dynamic inventory
│   └── hosts           # Static inventory
└── roles/
├── common/         # System packages
├── docker/         # Docker installation
├── java/           # Java 17 setup
└── jenkins/        # Jenkins installation
