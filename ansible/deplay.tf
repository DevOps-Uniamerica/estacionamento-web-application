provider "google" {
  project = "celtic-shape-452222-c9"
  region  = "southamerica-east1"
  credentials = file("credentials.json")
}

resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.vm_ssh_key.private_key_openssh
  filename        = "${path.module}/.ssh/gcp-vm-key.pem"
  file_permission = "0600" 
}


resource "local_file" "public_key" {
  content  = tls_private_key.vm_ssh_key.public_key_openssh
  filename = "${path.module}/.ssh/gcp-vm-key.pub"
}

resource "google_compute_instance" "vm" {
  name         = "vm-aplicacao"
  machine_type = "e2-micro"
  zone         = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.vm_ssh_key.public_key_openssh}"
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

output "ssh_private_key" {
  description = "Chave SSH privada para acesso à instância"
  value       = tls_private_key.vm_ssh_key.private_key_openssh
  sensitive   = true 
}

output "ssh_public_key" {
  description = "Chave SSH pública configurada na instância"
  value       = tls_private_key.vm_ssh_key.public_key_openssh
}
