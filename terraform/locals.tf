locals {
  # Common tags applied to all resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner_name
    Email       = var.owner_email
    Repository  = "github.com/yourname/CloudDevOpsProject"
    Purpose     = "Graduation-Project"
  }
  
  # Resource-specific tags
  network_tags = merge(
    local.common_tags,
    {
      Category = "Network"
    }
  )
  
  compute_tags = merge(
    local.common_tags,
    {
      Category   = "Compute"
      Backup     = "Daily"
      Monitoring = "Enabled"
    }
  )
}
