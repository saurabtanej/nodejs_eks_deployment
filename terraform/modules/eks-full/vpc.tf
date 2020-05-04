module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"
  name    = "${var.project_name}-vpc"
  cidr    = var.vpc_cidr

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = false

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  azs             = var.aws_region_azs
  private_subnets = var.vpc_subnet_private_cidrs
  public_subnets  = var.vpc_subnet_public_cidrs

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.project_name}-vpc"
    }
  )

  vpc_tags = {
    Role                                                    = "vpc"
    "kubernetes.io/cluster/${var.project_name}-eks-cluster" = "shared"
  }

  private_subnet_tags = {
    Name                                                    = "${var.project_name}-vpc-subnet-private"
    Role                                                    = "vpc-subnet"
    "kubernetes.io/role/elb"                                = "1"
    "kubernetes.io/cluster/${var.project_name}-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    Name                     = "${var.project_name}-vpc-subnet-public"
    Role                     = "vpc-subnet"
    "kubernetes.io/role/elb" = "1"
  }

  private_route_table_tags = {
    Name = "${var.project_name}-vpc-rt-private"
    Role = "vpc-route-table"
  }

  public_route_table_tags = {
    Name = "${var.project_name}-vpc-rt-public"
    Role = "vpc-route-table"
  }

  igw_tags = {
    Name = "${var.project_name}-vpc-igw"
    Role = "vpc-igw"
  }

  nat_gateway_tags = {
    Name = "${var.project_name}-vpc-nat"
    Role = "vpc-nat"
  }

  nat_eip_tags = {
    Name = "${var.project_name}-vpc-nat-eip"
    Role = "eip"
  }
}
