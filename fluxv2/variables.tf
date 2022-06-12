# ==================================================
# Variables: Common
# ==================================================

variable "chart_version" {
  type        = string
  description = "The helm chart version."
}

variable "namespace" {
  type    = string
  default = "tooling"
}

variable "release_name" {
  type        = string
  description = "The name of the release."
}

variable "watch_all_namespaces" {
  type    = bool
  default = true
}

variable "labels" {
  type = map(string)
}

variable "timeout" {
  type    = number
  default = 300
}

variable "image_pull_secret" {
  type        = string
  description = "If you want to pull the images from a private registry."
  default     = ""
}

# ==================================================
# Variables: GitRepositories and Kustomizations
# configurations
# ==================================================

variable "git_repositories" {
  type = map(object({
    git_url           = string
    git_branch        = string
    git_poll_interval = string
    git_public_key    = string
    git_private_key   = string
    git_known_hosts   = string
    git_timeout       = string

    kustomizations = map(object({
      path     = string
      interval = string
      prune    = bool
      wait     = bool
      timeout  = string
    }))
  }))
}

#  git_repositories = {
#    miniature-fiesta-flux-config = {
#      git_url              = "ssh://git@github.com/vmalier/miniature-fiesta-flux-config"
#      git_branch           = "master"
#      git_poll_interval    = "240m"
#      git_public_key       = "data.ansiblevault_string.git_public_key"
#      git_private_key      = "data.ansiblevault_string.git_private_key"
#      git_known_hosts      = "data.ansiblevault_string.git_known_hosts"
#      kustomizations = {
#        common = {
#          path     = "./common"
#          interval = "720m"
#          prune    = true
#          wait     = false
#          timeout  = "60s"
#        }
#        aws-common = {
#          path     = "./aws/common"
#          interval = "720m"
#          prune    = true
#          wait     = false
#          timeout  = "60s"
#        }
#        aws-dev = {
#          path     = ".aws/development"
#          interval = "720m"
#          prune    = true
#          wait     = false
#          timeout  = "60s"
#        }
#      }
#    }
#  }

# ==================================================
# Variables: Buckets and Kustomizations
# configurations
# ==================================================

variable "buckets" {
  type = map(object({
    endpoint          = string
    interval          = string
    insecure          = bool
    bucket_access_key = string
    bucket_secret_key = string

    kustomizations = map(object({
      path     = string
      interval = string
      prune    = bool
      wait     = bool
      timeout  = string
    }))
  }))
}

#  buckets = {
#    miniature-fiesta-bucket = {
#      endpoint             = "gitops.miniature-fiesta.com"
#      interval             = "240m"
#      insecure             = false
#      bucket_access_key    = "data.ansiblevault_string.bucket_access_key"
#      bucket_secret_key    = "data.ansiblevault_string.bucket_secret_key"
#      kustomizations = {
#        common = {
#          path     = "./common"
#          interval = "720m"
#          prune    = true
#          wait     = false
#          timeout  = "60s"
#        }
#        aws-dev = {
#          path     = ".aws/development"
#          interval = "720m"
#          prune    = true
#          wait     = false
#          timeout  = "60s"
#        }
#      }
#    }
#  }

# ==================================================
# Variables: Helm Controller related
# ==================================================

variable "helm_controller_create" {
  type    = bool
  default = true
}

variable "helm_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "helm_controller_concurrency" {
  type    = number
  default = 2
}

variable "helm_controller_cpu_limits" {
  type    = string
  default = "400m"
}

variable "helm_controller_cpu_requests" {
  type    = string
  default = "400m"
}

variable "helm_controller_memory_limits" {
  type    = string
  default = "2Gi"
}

variable "helm_controller_memory_requests" {
  type    = string
  default = "2Gi"
}

# ==================================================
# Variables: Image Automation Controller related
# ==================================================

variable "image_automation_controller_create" {
  type    = bool
  default = false
}

variable "image_automation_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "image_automation_controller_concurrency" {
  type    = number
  default = 1
}

variable "image_automation_controller_cpu_limits" {
  type    = string
  default = "200m"
}

variable "image_automation_controller_cpu_requests" {
  type    = string
  default = "200m"
}

variable "image_automation_controller_memory_limits" {
  type    = string
  default = "128Mi"
}

variable "image_automation_controller_memory_requests" {
  type    = string
  default = "128Mi"
}

# ==================================================
# Variables: Image Reflector Controller related
# ==================================================

variable "image_reflector_controller_create" {
  type    = bool
  default = false
}

variable "image_reflector_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "image_reflector_controller_concurrency" {
  type    = number
  default = 1
}

variable "image_reflector_controller_cpu_limits" {
  type    = string
  default = "200m"
}

variable "image_reflector_controller_cpu_requests" {
  type    = string
  default = "200m"
}

variable "image_reflector_controller_memory_limits" {
  type    = string
  default = "128Mi"
}

variable "image_reflector_controller_memory_requests" {
  type    = string
  default = "128Mi"
}

# ==================================================
# Variables: Notification Controller related
# ==================================================

variable "kustomize_controller_create" {
  type    = bool
  default = true
}

variable "kustomize_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "kustomize_controller_concurrency" {
  type    = number
  default = 2
}

variable "kustomize_controller_cpu_limits" {
  type    = string
  default = "500m"
}

variable "kustomize_controller_cpu_requests" {
  type    = string
  default = "500m"
}

variable "kustomize_controller_memory_limits" {
  type    = string
  default = "512Mi"
}

variable "kustomize_controller_memory_requests" {
  type    = string
  default = "512Mi"
}

# ==================================================
# Variables: Notification Controller related
# ==================================================

variable "notification_controller_create" {
  type    = bool
  default = true
}

variable "notification_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "notification_controller_concurrency" {
  type    = number
  default = 2
}

variable "notification_controller_cpu_limits" {
  type    = string
  default = "100m"
}

variable "notification_controller_cpu_requests" {
  type    = string
  default = "100m"
}

variable "notification_controller_memory_limits" {
  type    = string
  default = "512Mi"
}

variable "notification_controller_memory_requests" {
  type    = string
  default = "512Mi"
}

# ==================================================
# Variables: Source Controller related
# ==================================================

variable "source_controller_create" {
  type    = bool
  default = true
}

variable "source_controller_image" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "source_controller_concurrency" {
  type    = number
  default = 2
}

variable "source_controller_cpu_limits" {
  type    = string
  default = "700m"
}

variable "source_controller_cpu_requests" {
  type    = string
  default = "700m"
}

variable "source_controller_memory_limits" {
  type    = string
  default = "1Gi"
}

variable "source_controller_memory_requests" {
  type    = string
  default = "1Gi"
}
