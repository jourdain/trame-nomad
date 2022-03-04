job "trame-demo" {
  datacenters = ["dc1"]
  type = "batch"

  group "trame" {

    network {
      port "http" {}
    }

    task "demo" {
      driver = "docker"

      config {
        image = "jourdain/trame-apps:demo"
        args = [
            "--port", "${NOMAD_PORT_http}",
            "--authKey", "wslink-secret",
        ]
        ports = ["http"]
      }

      resources {
        cpu    = 100 # MHz
        memory = 50 # MB
      }

      service {
        # template on "${NOMAD_ALLOC_ID}"
        name = "trame-demo"
        tags = ["urlprefix-/${NOMAD_ALLOC_ID} strip=/${NOMAD_ALLOC_ID}"]
        port = "http"

        check {
           name     = "alive"
           type     = "tcp"
           interval = "30s"
           timeout  = "10s"
         }
      }
    }
  }
}
