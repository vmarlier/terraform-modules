# Sealed Secret

This module aims to ease the deployment of Sealed Secret. Here is a quick example:

```hcl
module "sealed_secret" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/sealed-secret"

  release_name  = "sealed-secret"
  chart_version = "2.2.0"

  tls_key = data.ansiblevault_string.tls_key.value # Feel free to use your favorite way of handling secrets
  tls_crt = data.ansiblevault_string.tls_crt.value # You can find an example of the ansiblevault way in this Readme

  service_monitor_labels = "default"
  grafana_dashboard      = true

  labels = {
    "app.kubernetes.io/name"       = "sealed-secret"
    "app.kubernetes.io/part-of"    = "gitops-tools"
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

data "ansiblevault_string" "tls_key" {
  encrypted = <<EOF
$ANSIBLE_VAULT;1.1;AES256
3731336134616333360a626631353835393135663936643239626435303462373764396462316563
EOF
}

data "ansiblevault_string" "tls_crt" {
  encrypted = <<EOF
$ANSIBLE_VAULT;1.1;AES256
63616238656139333131616633636663623333626633643039623830363331346662656132633430
EOF
}

module "sealed_secret" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/sealed-secret/"

  ...
  tls_key = data.ansiblevault_string.tls_key.value
  tls_crt = data.ansiblevault_string.tls_crt.value

}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.sealed-secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.sealed_secrets_tls](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The chart version of sealed secret helm release | `string` | n/a | yes |
| <a name="input_cpu_limits"></a> [cpu\_limits](#input\_cpu\_limits) | n/a | `string` | `"50m"` | no |
| <a name="input_cpu_requests"></a> [cpu\_requests](#input\_cpu\_requests) | n/a | `string` | `"50m"` | no |
| <a name="input_create_networkpolicy"></a> [create\_networkpolicy](#input\_create\_networkpolicy) | Specifies whether network policies should be created. | `bool` | `false` | no |
| <a name="input_create_psp"></a> [create\_psp](#input\_create\_psp) | Specifies whether PSP resources should be created. | `bool` | `false` | no |
| <a name="input_create_rbac"></a> [create\_rbac](#input\_create\_rbac) | Specifies whether RBAC resources should be created. | `bool` | `true` | no |
| <a name="input_grafana_dashboard"></a> [grafana\_dashboard](#input\_grafana\_dashboard) | Specifies wether grafana dashboard configmap should be created. | `bool` | `false` | no |
| <a name="input_image_pull_secret"></a> [image\_pull\_secret](#input\_image\_pull\_secret) | If you want to pull the images from a private registry. | `string` | `""` | no |
| <a name="input_image_registry"></a> [image\_registry](#input\_image\_registry) | Override the default image location if you want to use a custom registry. | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | n/a | yes |
| <a name="input_memory_limits"></a> [memory\_limits](#input\_memory\_limits) | n/a | `string` | `"64Mi"` | no |
| <a name="input_memory_requests"></a> [memory\_requests](#input\_memory\_requests) | n/a | `string` | `"64Mi"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which SealedSecret will be deployed. | `string` | `"tooling"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the release. | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the secret that will be used to store the TLS certificate. | `string` | `"sealed-secret-tls"` | no |
| <a name="input_service_monitor_labels"></a> [service\_monitor\_labels](#input\_service\_monitor\_labels) | The label of Sealed Secret Service Monitor. | `string` | `""` | no |
| <a name="input_tls_crt"></a> [tls\_crt](#input\_tls\_crt) | TLS certificate used by SealedSecret. | `string` | n/a | yes |
| <a name="input_tls_key"></a> [tls\_key](#input\_tls\_key) | TLS key used by SealedSecret. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Author

[Valentin Marlier](github.com/vmarlier)
