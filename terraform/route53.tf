module "route53-hostedzone" {
  source            = "./modules/route53-zone"
  name              = var.route53_public_hosted_zone
}

module "route53-record-app" {
  source            = "./modules/route53-record"
  name              = "${var.app_name}.${module.route53-hostedzone.name}"
  zone_id           = module.route53-hostedzone.zone_id
  alias_domain_name = module.eks-test.lb_dns_name
  alias_zone_id     = module.eks-test.lb_zone_id
}
