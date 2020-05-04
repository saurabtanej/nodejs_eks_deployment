resource "helm_release" "local" {
  name       = "tinyurl"
  chart      = "./helm/charts/tinyurl"
  namespace  = var.app_namespace

  depends_on = [
    module.eks-test
  ]
}
