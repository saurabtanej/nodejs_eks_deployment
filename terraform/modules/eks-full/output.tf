output "lb_dns_name" {
  description = "Load balancer dns name"
  value       = module.alb-public.dns_name
}

output "lb_zone_id" {
  description = "Load balancer zone id"
  value       = module.alb-public.load_balancer_zone_id
}
