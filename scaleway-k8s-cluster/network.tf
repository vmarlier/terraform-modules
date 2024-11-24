# ==================================================
# Resource: Network creation
# ==================================================

resource "scaleway_vpc_private_network" "pn_priv" {
    name = "pn_${var.cluster_name}"
    tags = var.shared_tags

    ipv4_subnet {
      subnet = "10.0.0.0/24"
    }
}
