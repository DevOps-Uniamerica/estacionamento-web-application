provider "google" {
  project = "infraestrutura-devops-stg"
  region  = "southamerica-east1"
  #credentials = file("C:/Users/Luis/Documents/Mensal4/final/stg/gcp-key.json") #- Credenciais locais apenas para teste local, na pipe deve ser utilizado o secrets do git
}

resource "google_container_cluster" "k8s_stg" {
  name     = "k8s-cluster-stg"
  location = "southamerica-east1"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = "default"
  subnetwork = "default"

  ip_allocation_policy {}
}

resource "google_container_node_pool" "k8s_stg_nodes" {
  name       = "stg-node-pool"
  location   = "southamerica-east1"
  cluster    = google_container_cluster.k8s_stg.name

  node_config {
    machine_type = "e2-medium"
    

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "stg"
    }

    tags = ["k8s", "stg"]
  }

  initial_node_count = 1
}

resource "google_compute_firewall" "allow_k8s_services" {
  name    = "allow-k8s-services"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "3000", "9090", "80", "443", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["k8s"]
}

output "cluster_name" {
  value = google_container_cluster.k8s_stg.name
}

output "cluster_location" {
  value = google_container_cluster.k8s_stg.location
}
