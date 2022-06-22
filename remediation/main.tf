variable "project" {}
variable "region" {}
variable "zone" {}

provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = "${var.region}"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.142.0.0/24"
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name                     = "${var.project}-gke"
  location                 = "${var.zone}"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
  release_channel {
    channel = "UNSPECIFIED"
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = "${var.zone}"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    machine_type = "e2-micro"
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}