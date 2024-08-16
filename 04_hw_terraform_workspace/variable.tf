variable "microservices_list" {
  type = list(string)
  default = [
    "api1",
    "api2"
  ]
}

variable "default_port" {
  description = "Default Port / Container Port"
  type        = number
  default     = 80
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "project_name" {
  description = "Devops Final"
  type        = string
  default = "devops_final"
}

variable "image_name" {
  description = "Prject Name"
  type        = string
  default = "htmldemo/hightech:1.0.1"
}

variable "cidr_block" {
  description = "This is CIDR CLOCK."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ecs_type" {
  description = "Use AWS Farget  ECS Service"
  type        = string
  default     = "FARGATE"
}