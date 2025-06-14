variable "project_id" {
  description = "GCP project ID"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}
variable "cluster_name" {
  description = "Nome do cluster GKE"
  type        = string
}
variable "node_count" {
  description = "Quantidade de nós"
  type        = number
  default     = 2
}
variable "machine_type" {
  description = "Tipo de máquina"
  type        = string
  default     = "e2-medium"
}
variable "gcs_bucket" {
  description = "Bucket GCS para o estado do Terraform"
  type        = string
}