
terraform {
  required_version = "~> 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0, < 6.0.0"
    }
  }
}
