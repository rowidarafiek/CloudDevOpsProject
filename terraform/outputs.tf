# Network Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

# Server Outputs
output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.server.instance_id
}

output "jenkins_public_ip" {
  description = "Jenkins public IP address"
  value       = module.server.public_ip
}

output "jenkins_url" {
  description = "Jenkins web interface URL"
  value       = module.server.jenkins_url
}

output "ssh_command" {
  description = "SSH command to connect to Jenkins"
  value       = module.server.ssh_command
}

# Instructions
output "next_steps" {
  description = "Next steps after deployment"
  value = <<-EOT
  
  ✅ Infrastructure deployed successfully!
  
  Jenkins URL: ${module.server.jenkins_url}
  SSH Command: ${module.server.ssh_command}
  
  Next steps:
  1. Wait 5 minutes for EC2 to initialize
  2. SSH into the server
  3. Run Ansible playbook to configure Jenkins
  4. Access Jenkins UI and complete setup
  
  EOT
}
