locals {
  k3s_version = "v1.27.2"
}

job "k3s" {
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
      check {
        name = "k3s-ready"
        type = "http"
        port = "k3s"
        path = "/readyz"
        interval = "10s"
        timeout = "2m"
        protocol = "https"
        tls_skip_verify = true
        initial_status = "critical"
        success_before_passing = 1
      }
    }
    affinity {
      attribute = "$${node.unique.name}"
      value = "node1"
    }
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/$${local.k3s_version}%2Bk3s1/k3s"
      }
      resources {
        cpu = 300
        memory = 500
      }
      config {
        command = "local/k3s"
        args    = [
          "server",
          "--cluster-init",
          "--token",
          "${token}",
          "--write-kubeconfig",
          "/home/vagrant/.nomad-k3s/config",
          "--write-kubeconfig-mode",
          "644",
          "--advertise-address",
          "$${attr.unique.network.ip-address}",
          "--node-ip",
          "$${attr.unique.network.ip-address}",
          "--flannel-iface",
          "eth1",
          "--tls-san",
          "k3s-a.service.consul",
          "--kube-apiserver-arg=anonymous-auth=true"
        ]
      }
    }
  }
  group "k3s-b" {
    network {
      port "k3s" {
        static = 6443
      }
    }
    service {
      name = "k3s-b"
      port = "k3s"
      check {
        name = "k3s-ready"
        type = "http"
        port = "k3s"
        path = "/readyz"
        interval = "10s"
        timeout = "2m"
        protocol = "https"
        tls_skip_verify = true
        initial_status = "critical"
        success_before_passing = 1
      }
    }
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/$${local.k3s_version}%2Bk3s1/k3s"
      }
      resources {
        cpu = 300
        memory = 500
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
          "--kube-apiserver-arg=anonymous-auth=true"
        ]
      }
    }
  }
  group "k3s-c" {
    network {
      port "k3s" {
        static = 6443
      }
    }
    service {
      name = "k3s-c"
      port = "k3s"
      check {
        name = "k3s-ready"
        type = "http"
        port = "k3s"
        path = "/readyz"
        interval = "10s"
        timeout = "2m"
        protocol = "https"
        tls_skip_verify = true
        initial_status = "critical"
        success_before_passing = 1
      }
    }
    task "server" {
      driver = "raw_exec"
      artifact {
        source = "https://github.com/k3s-io/k3s/releases/download/$${local.k3s_version}%2Bk3s1/k3s"
      }
      resources {
        cpu = 300
        memory = 500
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
          "--kube-apiserver-arg=anonymous-auth=true"
        ]
      }
    }
  }
}