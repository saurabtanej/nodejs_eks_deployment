module "eks-test" {
  source = "./modules/eks-full"

  project_name   = "k8s-test"
  aws_region     = var.aws_region
  aws_region_azs = var.aws_region_azs

  vpc_cidr                 = "10.50.0.0/16"
  vpc_subnet_private_cidrs = ["10.50.4.0/22", "10.50.8.0/22", "10.50.12.0/22"]
  vpc_subnet_public_cidrs  = ["10.50.16.0/22", "10.50.20.0/22", "10.50.24.0/22"]
  nginx_ingress_enabled    = true

  eks_map_users = [
    {
      userarn  = module.iam_user.this_iam_user_arn
      username = module.iam_user.this_iam_user_name
      groups   = ["system:masters"]
    }
  ]
}
