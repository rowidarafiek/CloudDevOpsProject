# terraform {
#   backend "s3" {
#     bucket = "clouddevops-tfstate-1763206314"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# Network Module
module "network" {
  source = "./modules/network"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  tags                = local.network_tags
}

# Server Module
module "server" {
  source = "./modules/server"
  project_name               = var.project_name
  vpc_id                     = module.network.vpc_id
  subnet_id                  = module.network.public_subnet_ids[0]
  instance_type              = var.instance_type
  ami_id                     = var.ami_id
  key_name                   = var.key_name
  jenkins_port               = var.jenkins_port
  app_port                   = var.app_port
  cpu_alarm_threshold        = var.cpu_alarm_threshold
  enable_detailed_monitoring = var.enable_detailed_monitoring
  tags                       = local.compute_tags

  depends_on = [module.network]
}


