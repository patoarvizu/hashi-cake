terraform {
  required_providers {
    boundary = {
      source = "hashicorp/boundary"
      version = "1.1.7"
    }
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