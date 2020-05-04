output "name" {
  description = "Route53 record dns name"
  value       = concat(aws_route53_record.this.*.name, [""])[0]
}
