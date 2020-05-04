module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = var.iam_username
  force_destroy = true

  password_reset_required = false
}
