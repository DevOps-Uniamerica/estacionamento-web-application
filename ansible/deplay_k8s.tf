terraform {
  required_version = ">= 1.1.0"
  required_providers {
    google = { source = "hashicorp/google" version = "~> 4.0" }
    google-beta = { source = "hashicorp/google-beta" version = "~> 4.0" }
  }
  backend "gcs" {
    bucket = var.gcs_bucket
    prefix = "terraform/state/gke"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
provider "google-beta" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-np"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count
  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}