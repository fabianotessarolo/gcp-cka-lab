variable "project" {}

provider "google" {
  project = var.project
  region  = "us-central1"
}

resource "google_compute_network" "cka-network" {
  name                    = "cka-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cka-subnetwork" {
  name          = "cka"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.cka-network.self_link
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    # network       = google_compute_network.cka-network.self_link
    subnetwork       = google_compute_subnetwork.cka-subnetwork.self_link
    access_config {
    }
  }
}