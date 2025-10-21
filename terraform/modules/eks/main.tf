module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Enable control plane logging for production readiness
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets
  
  # Control plane subnet IDs for multi-AZ high availability
  control_plane_subnet_ids = var.private_subnets

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
  }

  # Multi-AZ node groups for high availability
  eks_managed_node_groups = {
    # General purpose node group spread across all AZs
    general = {
      name = "general-purpose"
      
      desired_size = 3
      min_size     = 3
      max_size     = 6

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      # Ensure nodes are distributed across all AZs
      subnet_ids = var.private_subnets

      labels = {
        role = "general"
      }

      tags = {
        NodeGroup = "general-purpose"
      }
    }
  }

  tags = var.tags
}

# IAM role for EBS CSI driver
module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix = "${var.cluster_name}-ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}
