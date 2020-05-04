## Route53 zone module

Module example as public zone:

    module "foo" {
      source = "../modules/route53-zone"
      name   = "example.com"
    }

Module example as private zone:

    module "foo" {
      source  = "../modules/route53-zone"
      name    = "example.com"
      vpc_ids = ["vpc-12345"]
    }

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name of the Route53 hosted zone | string | n/a | yes |
| tag\_owner | Owner tag to associate with the Route53 hosted zone | string | `"devops"` | no |
| tag\_project | Project tag to associate with the Route53 hosted zone | string | `"infra"` | no |
| tags | List of maps of tags to add | map(string) | `{}` | no |
| vpc\_ids | VPC IDs to associate with the Route53 hosted zone, setting this option makes the route53 zone private | list(string) | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | Hosted zone name |
| name\_servers | List of name servers associated to the route53 hosted zone |
| zone\_id | Hosted zone ID |
