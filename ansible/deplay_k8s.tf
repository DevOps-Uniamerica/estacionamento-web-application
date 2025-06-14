
terraform {
  required_version = ">= 1.1.0"
  required_providers {
    google = { source = "hashicorp/google" version = "~> 4.0" }
    google-beta = { source = "hashicorp/google-beta" version = "~> 4.0" }
  }
}

# Variáveis obrigatórias
variable "project" {
  description = "GCP project ID"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
}
variable "zone" {
  description = "GCP zone"
  type        = string
}
variable "gcp_user" {
  description = "Usuário SSH para VM"
  type        = string
}
variable "ssh_key_pub" {
  description = "Chave pública SSH para acesso à VM"
  type        = string
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "vm" {
  name         = "vm-aplicacao"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 10
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.gcp_user}:${var.ssh_key_pub}"
  }

  tags = ["ssh", "http-server"]
}

resource "google_compute_firewall" "firewall" {
  name    = "allow-ssh-and-app"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

output "vm_ip_address" {
  description = "IP público da instância"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
