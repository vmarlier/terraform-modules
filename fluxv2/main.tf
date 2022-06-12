# ==================================================
# Resources: Fluxv2 RBACs
# ==================================================

resource "kubectl_manifest" "psp" {
  yaml_body = templatefile(
    "${path.module}/templates/rbac/psp.tftpl",
    {
      release_name = var.release_name
    }
  )
}

resource "kubectl_manifest" "role" {
  depends_on = [kubectl_manifest.psp]

  yaml_body = templatefile(
    "${path.module}/templates/rbac/role.tftpl",
    {
      release_name      = var.release_name
      release_namespace = var.namespace
    }
  )
}

resource "kubectl_manifest" "rolebinding" {
  depends_on = [kubectl_manifest.role]

  yaml_body = templatefile(
    "${path.module}/templates/rbac/rolebinding.tftpl",
    {
      release_name      = var.release_name
      release_namespace = var.namespace
    }
  )
}

resource "kubectl_manifest" "clusterrole" {
  yaml_body = templatefile(
    "${path.module}/templates/rbac/clusterrole.tftpl",
    {
      release_name = var.release_name
    }
  )
}

resource "kubectl_manifest" "clusterrolebinding" {
  depends_on = [kubectl_manifest.clusterrole]

  yaml_body = templatefile(
    "${path.module}/templates/rbac/clusterrolebinding.tftpl",
    {
      release_name      = var.release_name
      release_namespace = var.namespace
    }
  )
}

# ==================================================
# Resource: Fluxv2 Helm Release
# ==================================================

resource "helm_release" "fluxv2" {
  depends_on = [kubectl_manifest.rolebinding, kubectl_manifest.clusterrolebinding]

  name       = var.release_name
  repository = "https://fluxcd-community.github.io/helm-charts"
  chart      = "flux2"
  version    = var.chart_version

  namespace = var.namespace

  values = [
    templatefile("${path.module}/templates/chart-values.tftpl",
      {
        watch_all_namespaces = var.watch_all_namespaces
        labels               = indent(4, yamlencode(var.labels))
        service_labels       = indent(6, yamlencode(var.labels))
        timeout              = var.timeout
        image_pull_secret    = var.image_pull_secret

        # Helm Controller
        helm_controller_create          = var.helm_controller_create
        helm_controller_image           = var.helm_controller_image
        helm_controller_concurrency     = var.helm_controller_concurrency
        helm_controller_cpu_limits      = var.helm_controller_cpu_limits
        helm_controller_memory_limits   = var.helm_controller_memory_limits
        helm_controller_cpu_requests    = var.helm_controller_cpu_requests
        helm_controller_memory_requests = var.helm_controller_memory_requests

        # Image Automation Controller
        image_automation_controller_create          = var.image_automation_controller_create
        image_automation_controller_image           = var.image_automation_controller_image
        image_automation_controller_concurrency     = var.image_automation_controller_concurrency
        image_automation_controller_cpu_limits      = var.image_automation_controller_cpu_limits
        image_automation_controller_memory_limits   = var.image_automation_controller_memory_limits
        image_automation_controller_cpu_requests    = var.image_automation_controller_cpu_requests
        image_automation_controller_memory_requests = var.image_automation_controller_memory_requests

        # Image Reflector Controller
        image_reflector_controller_create          = var.image_reflector_controller_create
        image_reflector_controller_image           = var.image_reflector_controller_image
        image_reflector_controller_concurrency     = var.image_reflector_controller_concurrency
        image_reflector_controller_cpu_limits      = var.image_reflector_controller_cpu_limits
        image_reflector_controller_memory_limits   = var.image_reflector_controller_memory_limits
        image_reflector_controller_cpu_requests    = var.image_reflector_controller_cpu_requests
        image_reflector_controller_memory_requests = var.image_reflector_controller_memory_requests

        # Kustomize Controller
        kustomize_controller_create          = var.kustomize_controller_create
        kustomize_controller_image           = var.kustomize_controller_image
        kustomize_controller_concurrency     = var.kustomize_controller_concurrency
        kustomize_controller_cpu_limits      = var.kustomize_controller_cpu_limits
        kustomize_controller_memory_limits   = var.kustomize_controller_memory_limits
        kustomize_controller_cpu_requests    = var.kustomize_controller_cpu_requests
        kustomize_controller_memory_requests = var.kustomize_controller_memory_requests

        # Notification Controller
        notification_controller_create          = var.notification_controller_create
        notification_controller_image           = var.notification_controller_image
        notification_controller_concurrency     = var.notification_controller_concurrency
        notification_controller_cpu_limits      = var.notification_controller_cpu_limits
        notification_controller_memory_limits   = var.notification_controller_memory_limits
        notification_controller_cpu_requests    = var.notification_controller_cpu_requests
        notification_controller_memory_requests = var.notification_controller_memory_requests

        # Source Controller
        source_controller_create          = var.source_controller_create
        source_controller_image           = var.source_controller_image
        source_controller_concurrency     = var.source_controller_concurrency
        source_controller_cpu_limits      = var.source_controller_cpu_limits
        source_controller_memory_limits   = var.source_controller_memory_limits
        source_controller_cpu_requests    = var.source_controller_cpu_requests
        source_controller_memory_requests = var.source_controller_memory_requests
      }
    )
  ]
}

# ==================================================
# Resource: Fluxv2 GitRepositories resources
# Documentation: https://fluxcd.io/docs/components/source/gitrepositories/
# ==================================================

resource "kubernetes_secret" "flux_git_secrets" {
  depends_on = [helm_release.fluxv2]

  for_each = var.git_repositories

  metadata {
    name      = "fluxv2-git-deploy-${each.key}"
    namespace = var.namespace
  }

  type = "Opaque"
  data = {
    "identity"     = sensitive(each.value.git_private_key)
    "identity.pub" = sensitive(each.value.git_public_key)
    "known_hosts"  = sensitive(each.value.git_known_hosts)
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubectl_manifest" "flux_git_repositories" {
  depends_on = [helm_release.fluxv2]

  for_each = var.git_repositories
  yaml_body = templatefile(
    "${path.module}/templates/flux-gitrepository.tftpl",
    {
      namespace = var.namespace

      repository_name   = each.key
      git_poll_interval = each.value.git_poll_interval
      git_url           = each.value.git_url
      git_branch        = each.value.git_branch
      git_timeout       = each.value.git_timeout
    }
  )
}

# ==================================================
# Resource: Fluxv2 Buckets resources
# Documentation: https://fluxcd.io/docs/components/source/buckets/
# ==================================================

resource "kubernetes_secret" "flux_bucket_secrets" {
  depends_on = [helm_release.fluxv2]

  for_each = var.buckets

  metadata {
    name      = "fluxv2-bucket-deploy-${each.key}"
    namespace = var.namespace
  }

  type = "Opaque"
  data = {
    "accesskey" = sensitive(each.value.bucket_access_key)
    "secretkey" = sensitive(each.value.bucket_secret_key)
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubectl_manifest" "flux_buckets" {
  depends_on = [helm_release.fluxv2]

  for_each = var.buckets
  yaml_body = templatefile(
    "${path.module}/templates/flux-buckets.tftpl",
    {
      namespace = var.namespace

      bucket_name     = each.key
      bucket_endpoint = each.value.endpoint
      interval        = each.value.interval
      insecure        = each.value.insecure
    }
  )
}

# ==================================================
# Resource: Fluxv2 Kustomizations resources
# Documentation: https://fluxcd.io/docs/components/kustomize/kustomization/
# ==================================================

locals {
  # flatten ensures that this local value is a flat list of objects, rather than a list of lists of objects
  kustomizations = flatten([
    for git_repository_name, git_repository_values in var.git_repositories : [
      for kustomization_name, kustomization_values in git_repository_values.kustomizations : {

        git_repository_name = git_repository_name
        kustomization_name  = kustomization_name

        kustomization_interval = kustomization_values.interval
        kustomization_path     = kustomization_values.path
        kustomization_prune    = kustomization_values.prune
        kustomization_wait     = kustomization_values.wait
        kustomization_timeout  = kustomization_values.timeout
      }
    ]
  ])

  # flatten ensures that this local value is a flat list of objects, rather than a list of lists of objects
  kustomizations_buckets = flatten([
    for bucket_name, bucket_values in var.buckets : [
      for kustomization_name, kustomization_values in bucket_values.kustomizations : {

        bucket_name        = bucket_name
        kustomization_name = kustomization_name

        kustomization_interval = kustomization_values.interval
        kustomization_path     = kustomization_values.path
        kustomization_prune    = kustomization_values.prune
        kustomization_wait     = kustomization_values.wait
        kustomization_timeout  = kustomization_values.timeout
      }
    ]
  ])
}

resource "kubectl_manifest" "flux_kustomizations_from_gitrepositories" {
  depends_on = [kubectl_manifest.flux_git_repositories]

  # local.kustomizations is a list, so we must now project it into a map where each key is unique. We'll combine the git_repository and kustomizations keys to produce a single unique key per instance.
  for_each = {
    for kustomization_values in local.kustomizations : "${kustomization_values.git_repository_name}.${kustomization_values.kustomization_name}" => kustomization_values
  }

  yaml_body = templatefile(
    "${path.module}/templates/flux-kustomization.tftpl",
    {
      namespace = var.namespace

      source_kind        = "GitRepository"
      repository_name    = each.value.git_repository_name
      kustomization_name = each.value.kustomization_name

      kustomization_interval = each.value.kustomization_interval
      kustomization_path     = each.value.kustomization_path
      kustomization_prune    = each.value.kustomization_prune
      kustomization_wait     = each.value.kustomization_wait
      kustomization_timeout  = each.value.kustomization_timeout
    }
  )
}

resource "kubectl_manifest" "flux_kustomizations_from_buckets" {
  depends_on = [kubectl_manifest.flux_buckets]

  # local.kustomizations is a list, so we must now project it into a map where each key is unique. We'll combine the bucket and kustomizations keys to produce a single unique key per instance.
  for_each = {
    for kustomization_values in local.kustomizations_buckets : "${kustomization_values.bucket_name}.${kustomization_values.kustomization_name}" => kustomization_values
  }

  yaml_body = templatefile(
    "${path.module}/templates/flux-kustomization.tftpl",
    {
      namespace = var.namespace

      source_kind        = "Bucket"
      repository_name    = each.value.bucket_name
      kustomization_name = each.value.kustomization_name

      kustomization_interval = each.value.kustomization_interval
      kustomization_path     = each.value.kustomization_path
      kustomization_prune    = each.value.kustomization_prune
      kustomization_wait     = each.value.kustomization_wait
      kustomization_timeout  = each.value.kustomization_timeout
    }
  )
}
