# Kapsule cluster

This module aims to ease the creation of a Kapsule cluster on the Scaleway Cloud. Here is a quick example:

```hcl
module "kapsule" {
  source = "/Users/vmarlier/Git/vmarlier/terraform-modules/kapsule"

  cluster_name    = "EasyCluster"
  cluster_version = "1.23"
  cluster_cni     = "calico"

  shared_tags = [
    "team=sre",
    "environment=dev"
  ]

  node_pools = {
    default = {
      node_type = "DEV1-M"
      zone      = "fr-par-1"
      region    = "fr-par"

      scaling = {
        size     = 3
        min_size = 1
        max_size = 9
      }

      autoscaling         = false
      autohealing         = true
      container_runtime   = "containerd"
      placement_group_id  = ""
      wait_for_pool_ready = false

      upgrade_policy = {
        max_surge       = 0
        max_unavailable = 1
      }

      kubelet_args = {}

      tags = [
        "application=tenants",
        "type=shared"
      ]
    }
    privileged = {
      node_type = "DEV1-L"
      zone      = "fr-par-2"
      region    = "fr-par"

      scaling = {
        size     = 2
        min_size = 1
        max_size = 3
      }

      autoscaling         = false
      autohealing         = true
      container_runtime   = "containerd"
      placement_group_id  = ""
      wait_for_pool_ready = false

      upgrade_policy = {
        max_surge       = 0
        max_unavailable = 1
      }

      kubelet_args = {
        "--register-with-taints=nodepool=restricted:NoExecute"
      }

      tags = [
        "application=databases",
        "type=private"
      ]
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | 2.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [scaleway_k8s_cluster.cluster](https://registry.terraform.io/providers/scaleway/scaleway/2.2.1/docs/resources/k8s_cluster) | resource |
| [scaleway_k8s_pool.node_pool](https://registry.terraform.io/providers/scaleway/scaleway/2.2.1/docs/resources/k8s_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_admission_plugins"></a> [cluster\_admission\_plugins](#input\_cluster\_admission\_plugins) | The list of admission plugins to enable on the cluster. | `list(string)` | `null` | no |
| <a name="input_cluster_api_cert_sans"></a> [cluster\_api\_cert\_sans](#input\_cluster\_api\_cert\_sans) | Additional Subject Alternative Names for the Kubernetes API server certificate. | `list(string)` | `null` | no |
| <a name="input_cluster_auto_upgrade"></a> [cluster\_auto\_upgrade](#input\_cluster\_auto\_upgrade) | Cluster auto-upgrade configuration. | <pre>object({<br>    enable      = bool<br>    start_hour  = number<br>    day         = string<br>  })</pre> | <pre>{<br>  "day": "any",<br>  "enable": false,<br>  "start_hour": 0<br>}</pre> | no |
| <a name="input_cluster_autoscaler"></a> [cluster\_autoscaler](#input\_cluster\_autoscaler) | Cluster autoscaler configuration. | <pre>object({<br>    disable_scale_down                = bool<br>    scale_down_delay                  = string<br>    scale_down_unneeded_time          = string<br>    estimator                         = string<br>    expander                          = string<br>    ignore_daemonsets_utilization     = bool<br>    balance_similar_node_groups       = bool<br>    expandable_pods_priority_cutoff   = string<br>    scale_down_utilization_threshold  = number<br>    max_graceful_termination_sec      = number<br>  })</pre> | <pre>{<br>  "balance_similar_node_groups": false,<br>  "disable_scale_down": false,<br>  "estimator": "binpacking",<br>  "expandable_pods_priority_cutoff": "-10",<br>  "expander": "random",<br>  "ignore_daemonsets_utilization": false,<br>  "max_graceful_termination_sec": 600,<br>  "scale_down_delay": "10m",<br>  "scale_down_unneeded_time": "10m",<br>  "scale_down_utilization_threshold": 0.5<br>}</pre> | no |
| <a name="input_cluster_cni"></a> [cluster\_cni](#input\_cluster\_cni) | The CNI for the Kubernetes cluster. | `string` | `"calico"` | no |
| <a name="input_cluster_delete_additional_resources"></a> [cluster\_delete\_additional\_resources](#input\_cluster\_delete\_additional\_resources) | Delete additional resources like block volumes and loadbalancers that were created in Kubernetes on cluster deletion. | `bool` | `null` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | A description for the Kubernetes cluster. | `string` | `null` | no |
| <a name="input_cluster_feature_gates"></a> [cluster\_feature\_gates](#input\_cluster\_feature\_gates) | The list of the feature gates to enable on the cluster. | `list(string)` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_cluster_project_id"></a> [cluster\_project\_id](#input\_cluster\_project\_id) | The ID of the project the cluster is associated with. | `string` | `null` | no |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | The region in which the cluster should be created. | `string` | `null` | no |
| <a name="input_cluster_tags"></a> [cluster\_tags](#input\_cluster\_tags) | A map of tags to add to the Kubernetes cluster. | `list(string)` | `[]` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Wether the cluster is Kapsule or Multicloud. | `string` | `"kapsule"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Kubernetes node pools configurations. | <pre>map(object({<br>    node_type = string<br>    zone   = string<br>    region = string<br><br>    scaling = object({<br>      size     = number<br>      min_size = number<br>      max_size = number<br>    })<br><br>    autoscaling         = bool<br>    autohealing         = bool<br>    container_runtime   = string<br>    placement_group_id  = string<br>    wait_for_pool_ready = bool<br><br>    upgrade_policy = object({<br>      max_surge       = number<br>      max_unavailable = number<br>    })<br><br>    kubelet_args = map(string)<br>    tags         = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_shared_tags"></a> [shared\_tags](#input\_shared\_tags) | A map of tags to add to all resources. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The CA certificate of the Kubernetes API server. |
| <a name="output_cluster_host"></a> [cluster\_host](#output\_cluster\_host) | The URL of the Kubernetes API server. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the cluster. |
| <a name="output_cluster_kubeconfig"></a> [cluster\_kubeconfig](#output\_cluster\_kubeconfig) | The raw kubeconfig file. |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token to connect to the Kubernetes API server. |
| <a name="output_node_pools"></a> [node\_pools](#output\_node\_pools) | Details about the Kapsule node pools. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Author

[Valentin Marlier](github.com/vmarlier)
