terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "app_image" {
  name         = var.docker_image
  keep_locally = false
}

resource "docker_container" "app_container" {
  image = docker_image.app_image.image_id
  name  = var.container_name
  ports {
    internal = var.container_port
    external = var.host_port
  }
}