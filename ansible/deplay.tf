/*provider "google" {
  project = "celtic-shape-452222-c9"
  region  = "southamerica-east1"
}

resource "google_compute_instance" "vm" {
  name         = "vm-aplicacao"
  machine_type = "e2-micro"
  zone         = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size = 10
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.gcp_user}:${var.ssh_key_pub}"
  }

  tags = ["ssh", "http-server"]
}

resource "google_compute_firewall" "firewall" {
  name    = "allow-ssh-prometheus-grafana-app"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080","3000","9090"] 
  }

  source_ranges = ["0.0.0.0/0"] 
}

output "vm_ip_address" {
  description = "IP público da instância"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
*/