
resource "docker_container" "local" {
  image = var.image
  name  = "local"
  ports {
    internal = 3000
    external = 3000
  }
}
