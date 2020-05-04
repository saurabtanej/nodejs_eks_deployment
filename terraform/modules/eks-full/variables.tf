variable "project_name" {}

variable "aws_region" {}

variable "aws_region_azs" {
  type = list(string)
}

variable "vpc_cidr" {}

variable "vpc_subnet_private_cidrs" {
  type = list(string)
}

variable "vpc_subnet_public_cidrs" {
  type = list(string)
}

variable "my_home_IP" {
  default = "94.207.10.93/32"
}

variable "eks_worker_groups_launch_template" {
  default = [
    {
      asg_desired_capacity                     = 1
      asg_max_size                             = 3
      asg_min_size                             = 1
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      override_instance_types                  = ["m5.large", "t3.large"]
      autoscaling_enabled                      = true
      root_volume_size                         = 30
      protect_from_scale_in                    = true
      instance_type                            = "c5.large"
      kubelet_extra_args                       = "--node-labels=test.net/NetworkPerfCategory=low,test.net/cpu=8,test.net/memory=16-32,nodepool.test.net/name=LowMemoryPool"
    },
  ]
}

variable "eks_map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "nginx_ingress_enabled" {
  description = "Option whether to enable [nginx ingress controller](https://hub.helm.sh/charts/stable/nginx-ingress)"
  type        = bool
  default     = false
}

variable "nginx_ingress_chart_version" {
  description = "Nginx_ingress [nginx ingress controller chart version](https://hub.helm.sh/charts/stable/nginx-ingress)"
  default     = "1.33.0"
}

variable "nginx_ingress_namespace" {
  description = "nginx-ingress controller namespace"
  default     = "nginx-ingress"
}
