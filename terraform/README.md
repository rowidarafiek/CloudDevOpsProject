# Terraform Infrastructure

Infrastructure as Code for CloudDevOps project using AWS.

## 📋 Overview

This Terraform configuration provisions:

- VPC with public subnets
- EC2 instance for Jenkins
- Security groups
- Internet Gateway
- Network ACLs
- CloudWatch monitoring
- S3 backend for state
- DynamoDB for state locking

## 🏗️ Architecture
VPC (10.0.0.0/16)
├── Public Subnet 1 (10.0.1.0/24) - AZ 1a
│   └── EC2 Jenkins Server (t2.large)
├── Public Subnet 2 (10.0.2.0/24) - AZ 1b
├── Internet Gateway
├── Route Tables
└── Network ACLs
## 📁 Module Structure
terraform/
├── main.tf              # Main configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── backend.tf           # S3 backend
├── providers.tf         # AWS provider
├── locals.tf            # Local values
└── modules/
├── network/         # VPC, Subnets, IGW
└── server/          # EC2, Security Groups
