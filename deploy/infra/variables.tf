variable "region" {default = "us-east-1"}

variable "session_name" {default = "openweatherforecast-deployment"}

variable "app_name" {default = "OpenWeatherForecast Api"}

variable "environment" {}

variable "vpc_id" {}

variable "name_initials" { default = "openweather" }

variable "instance_type" { default = "t2.micro" }

variable "subnet_id" {}

variable "alb_subnets" {}

variable "domain_name" { default = "punamaws.click" }

variable "dns_name" { default = "openweather.punamaws.click" }

variable "internal" { default = false }

variable "inbound_cidr" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "ebs_root_volume_size" { default = "30" }

variable "aspnetcore_environment" {}