job "trame-demo" {
  datacenters = ["dc1"]
  type = "batch"

  group "trame" {

    network {
      port "http" {}
    }

    service {
      # template on "${NOMAD_ALLOC_ID}"
      name = "trame-demo"
      tags = ["urlprefix-/demo strip=/demo"]
      port = "http"

      check {
         name     = "alive"
         type     = "tcp"
         interval = "30s"
         timeout  = "10s"
       }
    }

    task "demo" {
      driver = "docker"

      config {
        image = "jourdain/trame-apps:demo"
        args = [
            "--port", "${NOMAD_PORT_http}",
        ]
        ports = ["http"]
      }

      resources {
        cpu    = 100 # MHz
        memory = 50 # MB
      }
    }
  }
}
