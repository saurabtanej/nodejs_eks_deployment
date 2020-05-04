module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "6.0.0"

  cluster_name = "${var.project_name}-eks-cluster"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  iam_path = "/eks/${var.project_name}-eks-cluster/"

  workers_group_defaults = {
    target_group_arns = concat(
      [module.alb-public.target_group_arns[0]]
    )
    enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
    public_ip       = false
    subnets         = module.vpc.private_subnets
  }

  worker_groups_launch_template        = var.eks_worker_groups_launch_template
  worker_additional_security_group_ids = [module.security-group-eks-worker-access.this_security_group_id]

  workers_additional_policies = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  map_users                     = var.eks_map_users
  write_kubeconfig              = "true"
  write_aws_auth_config         = "false"
  cluster_log_retention_in_days = 7

  tags = merge(local.common_tags, {
    "Name" = "${var.project_name}-eks-cluster"
    "Role" = "eks"
  })
}
