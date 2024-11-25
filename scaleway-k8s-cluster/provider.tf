terraform {
  required_version = ">= 1.1"

  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.47.0"
    }
  }
}
