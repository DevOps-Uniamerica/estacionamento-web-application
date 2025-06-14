// variables.tf
variable "gcp_user" {
  type        = string
  description = "Usuário SSH"
}

variable "ssh_key_pub" {
  type        = string
  description = "Chave pública SSH"
}

variable "project_id" {
  type        = string
  description = "ID do projeto GCP"
}

variable "region" {
  type        = string
  description = "Região onde criar recursos (ex: southamerica-east1)"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster GKE"
}

variable "node_count" {
  type        = number
  description = "Número inicial de nós no node pool"
  default     = 1
}
