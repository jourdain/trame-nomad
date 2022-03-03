job "trame-demo" {
  datacenters = ["dc1"]
  type = "batch"

  group "trame" {

    network {
      port "http" { to = 1234}
    }

    service {
      # template on "${NOMAD_ALLOC_ID}"
      name = "trame-demo"
      tags = ["urlprefix-/demo"]
      port = "http"

      # check {
      #   name     = "alive"
      #   type     = "tcp"
      #   interval = "10s"
      #   timeout  = "2s"
      # }
    }

    task "demo" {
      driver = "docker"

      config {
        image = "jourdain/trame-apps:demo"
        ports = ["http"]
        # "${NOMAD_PORT_http}"
        args = [
            "--port", "1234",
        ]
      }

      resources {
        cpu    = 100 # MHz
        memory = 256 # MB
      }
    }
  }
}
