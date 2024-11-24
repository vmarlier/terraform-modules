# ==================================================
# Resource: Cluster creation
# ==================================================

resource "scaleway_k8s_cluster" "cluster" {
  name        = var.cluster_name
  type        = var.cluster_type
  description = var.cluster_description
  version     = var.cluster_version
  cni         = var.cluster_cni

  region             = var.cluster_region
  project_id         = var.cluster_project_id
  private_network_id = scaleway_vpc_private_network.pn_priv.id

  tags = setunion(var.cluster_tags, var.shared_tags)

  feature_gates               = var.cluster_feature_gates
  admission_plugins           = var.cluster_admission_plugins
  apiserver_cert_sans         = var.cluster_api_cert_sans
  delete_additional_resources = var.cluster_delete_additional_resources

  auto_upgrade {
    enable                        = var.cluster_auto_upgrade.enable
    maintenance_window_start_hour = var.cluster_auto_upgrade.start_hour
    maintenance_window_day        = var.cluster_auto_upgrade.day
  }

  autoscaler_config {
    disable_scale_down               = var.cluster_autoscaler.disable_scale_down
    scale_down_delay_after_add       = var.cluster_autoscaler.scale_down_delay
    scale_down_unneeded_time         = var.cluster_autoscaler.scale_down_unneeded_time
    estimator                        = var.cluster_autoscaler.estimator
    expander                         = var.cluster_autoscaler.expander
    ignore_daemonsets_utilization    = var.cluster_autoscaler.ignore_daemonsets_utilization
    balance_similar_node_groups      = var.cluster_autoscaler.balance_similar_node_groups
    expendable_pods_priority_cutoff  = var.cluster_autoscaler.expandable_pods_priority_cutoff
    scale_down_utilization_threshold = var.cluster_autoscaler.scale_down_utilization_threshold
    max_graceful_termination_sec     = var.cluster_autoscaler.max_graceful_termination_sec
  }
}

# ==================================================
# Resource: Node Pools creation
# ==================================================

resource "scaleway_k8s_pool" "node_pool" {
  for_each = var.node_pools

  cluster_id = scaleway_k8s_cluster.cluster.id

  name        = each.key
  node_type   = each.value.node_type
  autoscaling = each.value.autoscaling
  size        = each.value.scaling.size
  min_size    = each.value.scaling.min_size
  max_size    = each.value.scaling.max_size
  autohealing = each.value.autohealing

  placement_group_id  = each.value.placement_group_id
  container_runtime   = each.value.container_runtime
  wait_for_pool_ready = each.value.wait_for_pool_ready
  zone                = each.value.zone
  region              = each.value.region
  kubelet_args        = each.value.kubelet_args

  tags = setunion(each.value.tags, var.shared_tags)

  upgrade_policy {
    max_surge       = each.value.upgrade_policy.max_surge
    max_unavailable = each.value.upgrade_policy.max_unavailable
  }
}
