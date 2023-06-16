terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.15.2"
    }
  }
}