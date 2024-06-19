terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.21.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "my_image" {
  name         = var.container_name
  keep_locally = true
}

resource "docker_container" "my_container" {
  image = docker_image.my_image.image_id
  name  = var.container_name
  ports {
    internal = 8080
    external = 80
  }
}

