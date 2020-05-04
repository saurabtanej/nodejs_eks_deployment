Module example:

    module "foo" {
      source  = "../modules/route53-record"
      zone_id = "AABBCC1122"
      name    = "a.foo.com"
      type    = "A"
      ttl     = "300"
      records = ["a.bar.com"]
    }

Module example with alias domain:

    module "foo" {
      source            = "../modules/route53-record"
      zone_id           = "AABBCC1122"
      name              = "a.foo.com"
      type              = "A"
      alias_domain_name = "a-bar.elb.amazonaws.com"
      alias_zone_id     = "XXYYZZ1122"
    }

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name of the Route53 record | string | n/a | yes |
| zone\_id | Id of the Route53 zone | string | n/a | yes |
| alias\_domain\_name | The alias domain name, REQUIRED for alias record | string | `""` | no |
| alias\_zone\_id | The alias zone id, REQUIRED for alias record | string | `""` | no |
| create | Condition if route53 record should be created | bool | `"true"` | no |
| records | A list of records to be added | list(string) | `[]` | no |
| ttl | Record TTL | number | `"300"` | no |
| type | Record type | string | `"A"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Route53 record dns name |

