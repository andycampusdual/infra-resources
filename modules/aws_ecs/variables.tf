# variables.tf
variable "environment" {
  description = "El entorno donde se desplegarán los recursos"
  type        = string
}
variable "container_insight_status" {
  type    = object({
    disable = bool
  })
  default = {
    disable = true
  }
  description = "Configuración para habilitar o deshabilitar Container Insights"
}
variable "agd_ecs" {
  description = "El nombre del clúster ECS"
  type        = string
  default     = "agd-ecs"  # Cambia por el nombre que desees
}

variable "nginx_task" {
  description = "ARN de la definición de tarea ECS para nginx"
  type        = string
}

variable "subnets" {
  description = "Lista de subredes para la configuración de red"
  type        = list(string)
}

variable "security_groups" {
  description = "Lista de grupos de seguridad para la configuración de red"
  type        = list(string)
}
