# Fluxv2

This module aims to ease the deployment of Fluxv2 to set up your GitOps tooling quickly. Here is a quick example:

```hcl
module "fluxv2" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/fluxv2"

  release_name  = "fluxv2"
  chart_version = "0.18.0"
  namespace     = "flux-system" # Namespace should be created before

  # Requests/Limits Resources adjusments
  helm_controller_cpu_requests    = "1000m"
  helm_controller_cpu_limits      = "1000m"
  helm_controller_memory_requests = "4Gi"
  helm_controller_memory_limits   = "4Gi"

  source_controller_cpu_requests    = "3000m"
  source_controller_cpu_limits      = "3000m"
  source_controller_memory_requests = "2Gi"
  source_controller_memory_limits   = "2Gi"

  git_repositories = {
    miniature-fiesta-flux-config = {
      git_url           = "ssh://git@github.com/vmarlier/miniature-fiesta-flux-config"
      git_branch        = "master"
      git_poll_interval = "1m"
      git_timeout       = "120s"
      git_public_key    = data.ansiblevault_string.git_public_key.value  # Feel free to use your favorite way of handling secrets
      git_private_key   = data.ansiblevault_string.git_private_key.value # You can find an example of the ansiblevault way in this Readme
      git_known_hosts   = data.ansiblevault_string.git_known_hosts.value
      kustomizations = {
        common = {
          path     = "./common"
          interval = "30m"
          prune    = true
          wait     = false
          timeout  = "60s"
        },
        dev-cluster = {
          path     = "./clusters/development"
          interval = "30m"
          prune    = true
          wait     = false
          timeout  = "60s"
        },
      }
    }
  }

  buckets = {}

  labels = {
    "app.kubernetes.io/name"       = "fluxv2"
    "app.kubernetes.io/part-of"    = "GitOps-tools"
  }
}
```

Here is another example where you want to use Buckets as source of your GitOps process (you can still use both GitRepositories and Buckets).
```hcl
module "fluxv2" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/fluxv2"

  release_name  = "fluxv2"
  chart_version = "0.18.0"
  namespace     = "flux-system" # Namespace should be created before

  # Requests/Limits Resources adjusments
  helm_controller_cpu_requests    = "1000m"
  helm_controller_cpu_limits      = "1000m"
  helm_controller_memory_requests = "4Gi"
  helm_controller_memory_limits   = "4Gi"

  source_controller_cpu_requests    = "3000m"
  source_controller_cpu_limits      = "3000m"
  source_controller_memory_requests = "2Gi"
  source_controller_memory_limits   = "2Gi"

  git_repositories = {}

  buckets = { # You can of course define multiple Buckets or GitRepositories in the map.
    miniature-fiesta-bucket = {
      endpoint             = "gitops.miniature-fiesta.com"
      interval             = "240m"
      insecure             = false
      bucket_access_key    = "data.ansiblevault_string.bucket_access_key"
      bucket_secret_key    = "data.ansiblevault_string.bucket_secret_key"
      kustomizations = {
        common = {
          path     = "./common"
          interval = "720m"
          prune    = true
          wait     = false
          timeout  = "60s"
        }
        aws-dev = {
          path     = ".aws/development"
          interval = "720m"
          prune    = true
          wait     = false
          timeout  = "60s"
        }
      }
    }
  }

  labels = {
    "app.kubernetes.io/name"       = "fluxv2"
    "app.kubernetes.io/part-of"    = "GitOps-tools"
  }
}
```

## Secrets Handling with the AnsibleVault Provider

For more information, I suggest you to go take a look at the [repository](https://github.com/MeilleursAgents/terraform-provider-ansiblevault).

```hcl
terraform {
  required_providers {
    ...
    ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "~> 2.2.0"
    }
  }
}

# Initialize a provider to read vaulted variables
provider "ansiblevault" {
  vault_pass  = "vaultPassStringOrPath"
  root_folder = "./"
}

data "ansiblevault_string" "bucket_access_key" {
  encrypted = <<EOF
$ANSIBLE_VAULT;1.1;AES256
3731336134616333360a626631353835393135663936643239626435303462373764396462316563
EOF
}

data "ansiblevault_string" "bucket_secret_key" {
  encrypted = <<EOF
$ANSIBLE_VAULT;1.1;AES256
63616238656139333131616633636663623333626633643039623830363331346662656132633430
EOF
}

module "fluxv2" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/fluxv2"

  ...

  buckets = {
    miniature-fiesta-bucket = {
      ...
      bucket_access_key    = "data.ansiblevault_string.bucket_access_key"
      bucket_secret_key    = "data.ansiblevault_string.bucket_secret_key"
      ...
    }
  }
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.13.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.13.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.fluxv2](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.clusterrole](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.clusterrolebinding](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.flux_buckets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.flux_git_repositories](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.flux_kustomizations_from_buckets](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.flux_kustomizations_from_gitrepositories](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.psp](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.role](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.rolebinding](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.flux_bucket_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.flux_git_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_buckets"></a> [buckets](#input\_buckets) | n/a | <pre>map(object({<br>    endpoint          = string<br>    interval          = string<br>    insecure          = bool<br>    bucket_access_key = string<br>    bucket_secret_key = string<br><br>    kustomizations = map(object({<br>      path     = string<br>      interval = string<br>      prune    = bool<br>      wait     = bool<br>      timeout  = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The helm chart version. | `string` | n/a | yes |
| <a name="input_git_repositories"></a> [git\_repositories](#input\_git\_repositories) | n/a | <pre>map(object({<br>    git_url           = string<br>    git_branch        = string<br>    git_poll_interval = string<br>    git_public_key    = string<br>    git_private_key   = string<br>    git_known_hosts   = string<br>    git_timeout       = string<br><br>    kustomizations = map(object({<br>      path     = string<br>      interval = string<br>      prune    = bool<br>      wait     = bool<br>      timeout  = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_helm_controller_concurrency"></a> [helm\_controller\_concurrency](#input\_helm\_controller\_concurrency) | n/a | `number` | `2` | no |
| <a name="input_helm_controller_cpu_limits"></a> [helm\_controller\_cpu\_limits](#input\_helm\_controller\_cpu\_limits) | n/a | `string` | `"400m"` | no |
| <a name="input_helm_controller_cpu_requests"></a> [helm\_controller\_cpu\_requests](#input\_helm\_controller\_cpu\_requests) | n/a | `string` | `"400m"` | no |
| <a name="input_helm_controller_create"></a> [helm\_controller\_create](#input\_helm\_controller\_create) | n/a | `bool` | `true` | no |
| <a name="input_helm_controller_image"></a> [helm\_controller\_image](#input\_helm\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_helm_controller_memory_limits"></a> [helm\_controller\_memory\_limits](#input\_helm\_controller\_memory\_limits) | n/a | `string` | `"2Gi"` | no |
| <a name="input_helm_controller_memory_requests"></a> [helm\_controller\_memory\_requests](#input\_helm\_controller\_memory\_requests) | n/a | `string` | `"2Gi"` | no |
| <a name="input_image_automation_controller_concurrency"></a> [image\_automation\_controller\_concurrency](#input\_image\_automation\_controller\_concurrency) | n/a | `number` | `1` | no |
| <a name="input_image_automation_controller_cpu_limits"></a> [image\_automation\_controller\_cpu\_limits](#input\_image\_automation\_controller\_cpu\_limits) | n/a | `string` | `"200m"` | no |
| <a name="input_image_automation_controller_cpu_requests"></a> [image\_automation\_controller\_cpu\_requests](#input\_image\_automation\_controller\_cpu\_requests) | n/a | `string` | `"200m"` | no |
| <a name="input_image_automation_controller_create"></a> [image\_automation\_controller\_create](#input\_image\_automation\_controller\_create) | n/a | `bool` | `false` | no |
| <a name="input_image_automation_controller_image"></a> [image\_automation\_controller\_image](#input\_image\_automation\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_image_automation_controller_memory_limits"></a> [image\_automation\_controller\_memory\_limits](#input\_image\_automation\_controller\_memory\_limits) | n/a | `string` | `"128Mi"` | no |
| <a name="input_image_automation_controller_memory_requests"></a> [image\_automation\_controller\_memory\_requests](#input\_image\_automation\_controller\_memory\_requests) | n/a | `string` | `"128Mi"` | no |
| <a name="input_image_pull_secret"></a> [image\_pull\_secret](#input\_image\_pull\_secret) | If you want to pull the images from a private registry. | `string` | `""` | no |
| <a name="input_image_reflector_controller_concurrency"></a> [image\_reflector\_controller\_concurrency](#input\_image\_reflector\_controller\_concurrency) | n/a | `number` | `1` | no |
| <a name="input_image_reflector_controller_cpu_limits"></a> [image\_reflector\_controller\_cpu\_limits](#input\_image\_reflector\_controller\_cpu\_limits) | n/a | `string` | `"200m"` | no |
| <a name="input_image_reflector_controller_cpu_requests"></a> [image\_reflector\_controller\_cpu\_requests](#input\_image\_reflector\_controller\_cpu\_requests) | n/a | `string` | `"200m"` | no |
| <a name="input_image_reflector_controller_create"></a> [image\_reflector\_controller\_create](#input\_image\_reflector\_controller\_create) | n/a | `bool` | `false` | no |
| <a name="input_image_reflector_controller_image"></a> [image\_reflector\_controller\_image](#input\_image\_reflector\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_image_reflector_controller_memory_limits"></a> [image\_reflector\_controller\_memory\_limits](#input\_image\_reflector\_controller\_memory\_limits) | n/a | `string` | `"128Mi"` | no |
| <a name="input_image_reflector_controller_memory_requests"></a> [image\_reflector\_controller\_memory\_requests](#input\_image\_reflector\_controller\_memory\_requests) | n/a | `string` | `"128Mi"` | no |
| <a name="input_kustomize_controller_concurrency"></a> [kustomize\_controller\_concurrency](#input\_kustomize\_controller\_concurrency) | n/a | `number` | `2` | no |
| <a name="input_kustomize_controller_cpu_limits"></a> [kustomize\_controller\_cpu\_limits](#input\_kustomize\_controller\_cpu\_limits) | n/a | `string` | `"500m"` | no |
| <a name="input_kustomize_controller_cpu_requests"></a> [kustomize\_controller\_cpu\_requests](#input\_kustomize\_controller\_cpu\_requests) | n/a | `string` | `"500m"` | no |
| <a name="input_kustomize_controller_create"></a> [kustomize\_controller\_create](#input\_kustomize\_controller\_create) | n/a | `bool` | `true` | no |
| <a name="input_kustomize_controller_image"></a> [kustomize\_controller\_image](#input\_kustomize\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_kustomize_controller_memory_limits"></a> [kustomize\_controller\_memory\_limits](#input\_kustomize\_controller\_memory\_limits) | n/a | `string` | `"512Mi"` | no |
| <a name="input_kustomize_controller_memory_requests"></a> [kustomize\_controller\_memory\_requests](#input\_kustomize\_controller\_memory\_requests) | n/a | `string` | `"512Mi"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"tooling"` | no |
| <a name="input_notification_controller_concurrency"></a> [notification\_controller\_concurrency](#input\_notification\_controller\_concurrency) | n/a | `number` | `2` | no |
| <a name="input_notification_controller_cpu_limits"></a> [notification\_controller\_cpu\_limits](#input\_notification\_controller\_cpu\_limits) | n/a | `string` | `"100m"` | no |
| <a name="input_notification_controller_cpu_requests"></a> [notification\_controller\_cpu\_requests](#input\_notification\_controller\_cpu\_requests) | n/a | `string` | `"100m"` | no |
| <a name="input_notification_controller_create"></a> [notification\_controller\_create](#input\_notification\_controller\_create) | n/a | `bool` | `true` | no |
| <a name="input_notification_controller_image"></a> [notification\_controller\_image](#input\_notification\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_notification_controller_memory_limits"></a> [notification\_controller\_memory\_limits](#input\_notification\_controller\_memory\_limits) | n/a | `string` | `"512Mi"` | no |
| <a name="input_notification_controller_memory_requests"></a> [notification\_controller\_memory\_requests](#input\_notification\_controller\_memory\_requests) | n/a | `string` | `"512Mi"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the release. | `string` | n/a | yes |
| <a name="input_source_controller_concurrency"></a> [source\_controller\_concurrency](#input\_source\_controller\_concurrency) | n/a | `number` | `2` | no |
| <a name="input_source_controller_cpu_limits"></a> [source\_controller\_cpu\_limits](#input\_source\_controller\_cpu\_limits) | n/a | `string` | `"700m"` | no |
| <a name="input_source_controller_cpu_requests"></a> [source\_controller\_cpu\_requests](#input\_source\_controller\_cpu\_requests) | n/a | `string` | `"700m"` | no |
| <a name="input_source_controller_create"></a> [source\_controller\_create](#input\_source\_controller\_create) | n/a | `bool` | `true` | no |
| <a name="input_source_controller_image"></a> [source\_controller\_image](#input\_source\_controller\_image) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_source_controller_memory_limits"></a> [source\_controller\_memory\_limits](#input\_source\_controller\_memory\_limits) | n/a | `string` | `"1Gi"` | no |
| <a name="input_source_controller_memory_requests"></a> [source\_controller\_memory\_requests](#input\_source\_controller\_memory\_requests) | n/a | `string` | `"1Gi"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `number` | `300` | no |
| <a name="input_watch_all_namespaces"></a> [watch\_all\_namespaces](#input\_watch\_all\_namespaces) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Author

[Valentin Marlier](github.com/vmarlier)
