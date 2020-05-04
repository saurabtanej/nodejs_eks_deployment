variable "name" {
  description = "Name of the Route53 record"
}

variable "zone_id" {
  description = "Id of the Route53 zone"
}

variable "create" {
  description = "Condition if route53 record should be created"
  type        = bool
  default     = true
}

variable "allow_overwrite" {
  description = "Condition if route53 record should be overwritten"
  type        = bool
  default     = false
}

variable "type" {
  description = "Record type"
  default     = "A"
}

variable "ttl" {
  description = "Record TTL"
  type        = number
  default     = 300
}

variable "alias_domain_name" {
  description = "The alias domain name, REQUIRED for alias record"
  default     = ""
}

variable "alias_zone_id" {
  description = "The alias zone id, REQUIRED for alias record"
  default     = ""
}

variable "records" {
  description = "A list of records to be added"
  type        = list(string)
  default     = []
}
