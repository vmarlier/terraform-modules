# ==================================================
# Resource: Secret configruation for Sealed
# Secret TLS key and crt.
# ==================================================

resource "kubernetes_secret" "sealed_secrets_tls" {

  metadata {
    name      = var.secret_name
    namespace = var.namespace
  }

  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = var.tls_crt
    "tls.key" = var.tls_key
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
    ]
  }
}

# ==================================================
# Resource: Sealed Secret Helm release
# ==================================================

resource "helm_release" "sealed-secrets" {
  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = var.chart_version
  namespace  = var.namespace

  values = [
    templatefile("${path.module}/templates/chart-values.tftpl",
      {
        namespace = var.namespace

        create_rbac          = var.create_rbac
        create_psp           = var.create_psp
        create_networkpolicy = var.create_networkpolicy

        secret_name            = var.secret_name
        service_monitor_labels = var.service_monitor_labels

        cpu_requests    = var.cpu_requests
        cpu_limits      = var.cpu_limits
        memory_requests = var.memory_requests
        memory_limits   = var.memory_limits

        image_registry    = var.image_registry
        image_pull_secret = var.image_pull_secret

        grafana_dashboard = var.grafana_dashboard
        labels            = indent(2, yamlencode(var.labels))
      }
    )
  ]
}
