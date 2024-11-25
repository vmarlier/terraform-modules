# ==================================================
# Variables: Cluster
# References: https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/k8s_cluster#arguments-reference
# ==================================================

variable "cluster_name" {
  type        = string
  description = "The name of the Kubernetes cluster."
}

variable "cluster_region" {
  type        = string
  description = "The region in which the cluster should be created."
  default     = null
}

variable "cluster_project_id" {
  type        = string
  description = "The ID of the project the cluster is associated with."
  default     = null
}

variable "cluster_type" {
  type        = string
  description = "Wether the cluster is Kapsule (Mutualized), Dedicated or Multicloud."
  default     = "kapsule"
}

variable "cluster_description" {
  type        = string
  description = "A description for the Kubernetes cluster."
  default     = null
}

variable "cluster_version" {
  type        = string
  description = "The version of the Kubernetes cluster."
}

variable "cluster_cni" {
  type        = string
  description = "The CNI for the Kubernetes cluster."
  default     = "calico"
}

variable "cluster_auto_upgrade" {
  type = object({
    enable     = bool
    start_hour = number
    day        = string
  })
  description = "Cluster auto-upgrade configuration."
  default = {
    enable     = false
    start_hour = 0
    day        = "any"
  }
}

variable "cluster_autoscaler" {
  type = object({
    disable_scale_down               = bool
    scale_down_delay                 = string
    scale_down_unneeded_time         = string
    estimator                        = string
    expander                         = string
    ignore_daemonsets_utilization    = bool
    balance_similar_node_groups      = bool
    expandable_pods_priority_cutoff  = string
    scale_down_utilization_threshold = number
    max_graceful_termination_sec     = number
  })
  description = "Cluster autoscaler configuration."
  default = {
    disable_scale_down               = false
    scale_down_delay                 = "10m"
    scale_down_unneeded_time         = "10m"
    estimator                        = "binpacking"
    expander                         = "random"
    ignore_daemonsets_utilization    = false
    balance_similar_node_groups      = false
    expandable_pods_priority_cutoff  = "-10"
    scale_down_utilization_threshold = 0.5
    max_graceful_termination_sec     = 600
  }
}

variable "cluster_feature_gates" {
  type        = list(string)
  description = "The list of the feature gates to enable on the cluster."
  default     = null
}

variable "cluster_admission_plugins" {
  type        = list(string)
  description = "The list of admission plugins to enable on the cluster."
  default     = null
}

variable "cluster_api_cert_sans" {
  type        = list(string)
  description = "Additional Subject Alternative Names for the Kubernetes API server certificate."
  default     = null
}

variable "cluster_delete_additional_resources" {
  type        = bool
  description = "Delete additional resources like block volumes and loadbalancers that were created in Kubernetes on cluster deletion."
  default     = false
}

variable "cluster_tags" {
  type        = list(string)
  description = "A map of tags to add to the Kubernetes cluster."
  default     = []
}

variable "private_network_id" {
  type = string
  description = "The ID of the private network of the cluster."
  default = ""
}

# ==================================================
# Variables: Node Pool(s)
# References: https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/k8s_pool#arguments-reference
# ==================================================

variable "node_pools" {
  type = map(object({
    node_type = string
    zone      = string
    region    = string

    scaling = object({
      size     = number
      min_size = number
      max_size = number
    })

    autoscaling         = bool
    autohealing         = bool
    container_runtime   = string
    placement_group_id  = string
    wait_for_pool_ready = bool

    upgrade_policy = object({
      max_surge       = number
      max_unavailable = number
    })

    kubelet_args = map(string)
    tags         = list(string)
  }))
  description = "Kubernetes node pools configurations."
}

# ==================================================
# Variables: Shared between resources
# ==================================================

variable "shared_tags" {
  type        = list(string)
  description = "A map of tags to add to all resources."
  default     = null
}
