# ==================================================
# Variables: Chart
# ==================================================

variable "release_name" {
  type        = string
  description = "The name of the release."
}

variable "namespace" {
  type        = string
  description = "The namespace in which SealedSecret will be deployed."
  default     = "tooling"
}

variable "tls_key" {
  type        = string
  description = "TLS key used by SealedSecret."
}

variable "tls_crt" {
  type        = string
  description = "TLS certificate used by SealedSecret."
}

variable "chart_version" {
  type        = string
  description = "The chart version of sealed secret helm release"
}

variable "secret_name" {
  type        = string
  description = "The name of the secret that will be used to store the TLS certificate."
  default     = "sealed-secret-tls"
}

variable "create_rbac" {
  type        = bool
  description = "Specifies whether RBAC resources should be created."
  default     = true
}

variable "create_psp" {
  type        = bool
  description = "Specifies whether PSP resources should be created."
  default     = false
}

variable "create_networkpolicy" {
  type        = bool
  description = "Specifies whether network policies should be created."
  default     = false
}

variable "grafana_dashboard" {
  type        = bool
  description = "Specifies wether grafana dashboard configmap should be created."
  default     = false
}

variable "service_monitor_labels" {
  type        = string
  description = "The label of Sealed Secret Service Monitor."
  default     = ""
}

variable "image_registry" {
  type        = string
  description = "Override the default image location if you want to use a custom registry."
  default     = ""
}

variable "image_pull_secret" {
  type        = string
  description = "If you want to pull the images from a private registry."
  default     = ""
}

variable "labels" {
  type = map(string)
}

# ==================================================
# Variables: Resources Allocation
# ==================================================

variable "cpu_limits" {
  type    = string
  default = "50m"
}

variable "cpu_requests" {
  type    = string
  default = "50m"
}

variable "memory_limits" {
  type    = string
  default = "64Mi"
}

variable "memory_requests" {
  type    = string
  default = "64Mi"
}
