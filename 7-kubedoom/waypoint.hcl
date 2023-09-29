project = "kubedoom"

app "kubedoom" {
  build {
    use "docker-ref" {
      image = "ghcr.io/storax/kubedoom"
      tag = "latest"
    }
  }
  deploy {
    use "helm" {
      name = "kubedoom"
      create_namespace = true
      namespace = "kubedoom"
      chart = "${path.app}/charts/kubedoom"
      kubeconfig = "${pathexpand("~")}/.nomad-k3s/config"
    }
  }
  url {
    auto_hostname = false
  }
}