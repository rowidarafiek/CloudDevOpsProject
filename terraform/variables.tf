variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "clouddevops"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "owner_name" {
  description = "Owner name for tags"
  type        = string
  default     = "Your Name"
}

variable "owner_email" {
  description = "Owner email for tags"
  type        = string
  default     = "your.email@example.com"
}

# Network Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Server Variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = ""  # Will be auto-detected if empty
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "jenkins_port" {
  description = "Jenkins web interface port"
  type        = number
  default     = 8080
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5000
}

# CloudWatch Variables
variable "cpu_alarm_threshold" {
  description = "CPU utilization threshold for alarm"
  type        = number
  default     = 80
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed EC2 monitoring"
  type        = bool
  default     = true
}
