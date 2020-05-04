variable "name" {
  description = "Name of the Route53 hosted zone"
}

variable "vpc_ids" {
  description = "VPC IDs to associate with the Route53 hosted zone, setting this option makes the route53 zone private"
  type        = list(string)
  default     = []
}

variable "tag_project" {
  description = "Project tag to associate with the Route53 hosted zone"
  default     = "infra"
}

variable "tag_owner" {
  description = "Owner tag to associate with the Route53 hosted zone"
  default     = "devops"
}

variable "tags" {
  description = "List of maps of tags to add"
  type        = map(string)
  default     = {}
}
