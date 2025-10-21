locals {
  project_name = "multi-az-3tier"
  tags = {
    Project = local.project_name
    Managed = "Terraform"
  }
}

module "vpc" {
  source       = "./modules/vpc"
  name         = "multi-az-vpc"
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  tags         = local.tags
}
module "eks" {
  source = "./modules/eks"

  cluster_name   = var.cluster_name
  vpc_id         = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  tags         = local.tags
}
