/**
 * Module example:
 *
 *     module "foo" {
 *       source  = "./modules/route53-record"
 *       zone_id = "AABBCC1122"
 *       name    = "a.foo.com"
 *       type    = "A"
 *       ttl     = "300"
 *       records = ["a.bar.com"]
 *     }
 *
 * Module example with alias domain:
 *
 *     module "foo" {
 *       source            = "./modules/route53-record"
 *       zone_id           = "AABBCC1122"
 *       name              = "a.foo.com"
 *       type              = "A"
 *       alias_domain_name = "a-bar.elb.amazonaws.com"
 *       alias_zone_id     = "XXYYZZ1122"
 *     }
 *
 */

locals {
  create_alias = (var.alias_domain_name != "" && var.alias_zone_id != "") ? true : false
  alias_config = {
    "false" = []
    "true" = [{
      name    = var.alias_domain_name
      zone_id = var.alias_zone_id
    }]
  }
}

resource "aws_route53_record" "this" {
  count           = var.create ? 1 : 0
  zone_id         = var.zone_id
  name            = var.name
  type            = var.type
  ttl             = ! local.create_alias ? var.ttl : null
  records         = ! local.create_alias ? var.records : null
  allow_overwrite = var.allow_overwrite
  dynamic "alias" {
    for_each = local.alias_config[local.create_alias]
    content {
      name                   = lookup(alias.value, "name", null)
      zone_id                = lookup(alias.value, "zone_id", null)
      evaluate_target_health = true
    }
  }
}
