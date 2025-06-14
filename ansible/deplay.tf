// deplay.tf
provider "google" {
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
      size  = 10
    }
  }

  network_interface {
    network       = "default"
    access_config {}  # atribui IP externo
  }

  metadata_startup_script = "" # seu script, se houver

  tags = ["allow-ssh", "allow-app"]
}

resource "google_compute_firewall" "allow-ssh-and-app" {
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

# ──────────────────────────────────────────────────────────────────────────────
# GKE cluster + node pool

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  remove_default_node_pool = true
  initial_node_count = 1

  network    = "default"
  ip_allocation_policy {}  # habilita auto IPs de pod e serviços

  # habilita API Kubernetes Dashboard e demais addons se quiser
  addons_config {
    http_load_balancing {}
    kubernetes_dashboard {}
  }

  release_channel {
    channel = "REGULAR"
  }

  # habilita network policy no cluster
  network_policy {
    enabled = true
    provider = "CALICO"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    machine_type = "e2-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

output "gke_endpoint" {
  description = "Endereço do endpoint do cluster GKE"
  value       = google_container_cluster.primary.endpoint
}

output "gke_cluster_ca_certificate" {
  description = "CA certificate para conexão ao cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}
