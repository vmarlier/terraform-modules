# ==================================================
# Outputs: Cluster related
# References: https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/k8s_cluster#attributes-reference
# ==================================================

output "cluster_id" {
  value = scaleway_k8s_cluster.cluster.id
}

output "cluster_kubeconfig" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig[0].config_file
  sensitive = true
}

output "cluster_host" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig[0].host
  sensitive = true
}

output "cluster_token" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig[0].token
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig[0].cluster_ca_certificate
  sensitive = true
}

# ==================================================
# Outputs: Node Pool(s) related
# References: https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/k8s_pool#attributes-reference
# ==================================================

output "node_pools" {
  description = "Details about the Kapsule node pools."
  value = { for k, v in scaleway_k8s_pool.node_pool :
    k => {
      nodes = v.nodes
      id    = v.id
    }
  }
}
