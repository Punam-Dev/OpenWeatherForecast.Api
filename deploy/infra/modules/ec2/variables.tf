variable "ami" {}
variable "instance_type" {}
variable "subnet_id" { type = list(string) }
variable "instance_profile" {}
variable "ebs_root_volume_size" {}
variable "ec2_sg" {}
variable "aspnetcore_environment" {}
variable "environment" {}