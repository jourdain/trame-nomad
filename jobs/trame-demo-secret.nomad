job "trame-demo-secret" {
  datacenters = ["dc1"]
  type = "batch"


  parameterized {
    payload       = "forbidden"
    meta_required = ["SECRET"]
  }

  group "trame" {

    network {
      port "http" {}
    }

    task "demo" {
      driver = "docker"

      config {
        image = "jourdain/trame-apps:demo"
        force_pull=true
        args = [
            "--port", "${NOMAD_PORT_http}",
            "--authKey", "${NOMAD_META_SECRET}",
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
