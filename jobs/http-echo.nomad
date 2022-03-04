job "http-echo" {
    datacenters = ["dc1"]
    type = "service"

    group "echo" {
        count = 1

        network {
            port "http" {}
        }

        service {
            name = "echo"
            tags = ["urlprefix-/echo"]
            port = "http"
            check {
                name = "alive"
                type = "tcp"
                interval = "10s"
                timeout = "2s"
            }
        }

        task "server" {
            driver = "docker"

            config {
                image = "hashicorp/http-echo:latest"
                args  = [
                    "-listen", ":${NOMAD_PORT_http}",
                    "-text", "Hello and welcome to ${NOMAD_IP_http} running on port ${NOMAD_PORT_http}",
                ]
                ports = ["http"]
            }

            resources {
                cpu    = 500 # MHz
                memory = 128 # MB
            }
        }
    }
}