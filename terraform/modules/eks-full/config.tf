resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      aws eks --region ${var.aws_region} update-kubeconfig --name ${var.project_name}-eks-clusters
EOT
  }
}

resource "helm_release" "nginx_ingress" {
  count        = var.nginx_ingress_enabled ? 1 : 0
  name         = "nginx-ingress"
  namespace    = var.nginx_ingress_namespace
  repository   = data.helm_repository.stable.metadata[0].name
  chart        = "nginx-ingress"
  reuse_values = "true"
  version      = var.nginx_ingress_chart_version
  values       = [file("${path.module}/files/nginx-ingress.values.yaml")]

  depends_on = [
    module.eks
  ]
}
