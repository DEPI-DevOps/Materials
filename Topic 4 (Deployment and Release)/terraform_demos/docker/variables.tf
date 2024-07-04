variable "docker_image" {
  description = "Docker image to run"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "my_app_container"
}

variable "container_port" {
  description = "Internal port the container listens on"
  type        = number
  default     = 80
}

variable "host_port" {
  description = "Host port to map to the container port"
  type        = number
  default     = 8080
}