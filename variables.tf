variable "project" {
  type        = string
  description = "Nom du projet, utilisé dans les noms et les chemins SSM"
}

variable "environment" {
  type        = string
  description = "Environnement : dev ou prod"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment doit valoir dev ou prod"
  }
}

variable "vpc_id" {
  type        = string
  description = "ID du VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets publics"
}

variable "ami_id" {
  type        = string
  description = "AMI utilisée par le Launch Template"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Type d'instance"
}

variable "instance_profile_name" {
  type        = string
  description = "Nom du profil IAM des instances (LabInstanceProfile)"
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Taille minimale de l'ASG"
}

variable "max_size" {
  type        = number
  default     = 4
  description = "Taille maximale de l'ASG"
}

variable "secret_name" {
  type        = string
  default     = "app-secret"
  description = "Nom du paramètre SSM du secret. Chemin complet : /<project>/<environment>/<secret_name>"
}