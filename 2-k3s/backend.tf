terraform {
  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}