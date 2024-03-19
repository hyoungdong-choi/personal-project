variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version to use for the EKS cluster."
}

variable "fargate_profile_name" {
  type        = string
  description = "The name of the Fargate profile."
}

variable "fargate_profile_selector_namespace" {
  type        = list(string)
  description = "The list of Kubernetes namespaces that the Fargate profile will target."
  default     = ["default"]
}

variable "cluster_role" {
  type = string
}

variable "private_subnet" {
  type = list(string)
}

variable "fargate_role" {
  type = string
}