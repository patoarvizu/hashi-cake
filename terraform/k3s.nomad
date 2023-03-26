job "k3s" {
  datacenters = ["dc1"]
  constraint {
    operator = "distinct_hosts"
    value = "true"
  }
  group "k3s-a" {
    network {
      port "k3s" {
        static = 6443
      }
    }
    service {
      name = "k3s-a"
      port = "k3s"
    }
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/v1.22.17%2Bk3s1/k3s"
      }
      config {
        command = "local/k3s"
        args    = [
          "server",
          "--cluster-init",
          "--token",
          "${token}",
          "--write-kubeconfig",
          "/vagrant/nomad-k3s.yaml",
          "--write-kubeconfig-mode",
          "644",
          "--advertise-address",
          "$${attr.unique.network.ip-address}",
          "--node-ip",
          "$${attr.unique.network.ip-address}",
          "--flannel-iface",
          "eth1",
          "--tls-san",
          "k3s-a.service.consul"
        ]
      }
    }
  }
  group "k3s-b" {
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/v1.22.17%2Bk3s1/k3s"
      }
      config {
        command = "local/k3s"
        args    = [
          "server",
          "--token",
          "${token}",
          "--advertise-address",
          "$${attr.unique.network.ip-address}",
          "--node-ip",
          "$${attr.unique.network.ip-address}",
          "--flannel-iface",
          "eth1",
          "--server",
          "https://k3s-a.service.consul:6443",
        ]
      }
    }
  }
  group "k3s-c" {
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/v1.22.17%2Bk3s1/k3s"
      }
      config {
        command = "local/k3s"
        args    = [
          "server",
          "--token",
          "${token}",
          "--advertise-address",
          "$${attr.unique.network.ip-address}",
          "--node-ip",
          "$${attr.unique.network.ip-address}",
          "--flannel-iface",
          "eth1",
          "--server",
          "https://k3s-a.service.consul:6443",
        ]
      }
    }
  }
}