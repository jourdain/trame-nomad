job "trame-www" {
  datacenters = ["dc1"]
  type = "service"

  group "trame" {

    network {
      port "http" { to = 80 }
    }

    service {
      # template on "${NOMAD_ALLOC_ID}"
      name = "trame-www"
      tags = ["urlprefix-/"]
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
        image = "jourdain/trame-apps:www"
        ports = ["http"]
      }

      resources {
        cpu    = 100 # MHz
        memory = 256 # MB
      }
    }
  }
}
