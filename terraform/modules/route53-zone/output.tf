output "zone_id" {
  description = "Hosted zone ID"
  value       = aws_route53_zone.default.zone_id
}

output "name" {
  description = "Hosted zone name"
  value       = aws_route53_zone.default.name
}

output "name_servers" {
  description = "List of name servers associated to the route53 hosted zone"
  value       = aws_route53_zone.default.name
}
