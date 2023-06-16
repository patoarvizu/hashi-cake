provider "helm" {
  kubernetes {
    config_path = "~/.nomad-k3s/config"
  }
}

provider "kubernetes" {
  config_path = "~/.nomad-k3s/config"
}