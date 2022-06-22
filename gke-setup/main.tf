module "gke-cluster" {
  source       = "../modules/gke-cluster"

  project      = "cloudmatos"
  region       = "us-east1"
  zone         = "us-east1-b"
  auto_repair  = false
  auto_upgrade = false
}