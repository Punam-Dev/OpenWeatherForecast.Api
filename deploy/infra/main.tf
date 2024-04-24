data "aws_ami" "image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"] # Canonical
}

module "sg" {
  source = "./modules/sg"
  app_name = var.app_name
  vpc_id = var.vpc_id
  inbound_cidr = var.inbound_cidr
}

module "ec2" {
  source = "./modules/ec2"
  subnet_id = var.subnet_id
  aspnetcore_environment = var.aspnetcore_environment
  ami = data.aws_ami.image.id
  instance_type = var.instance_type
  instance_profile = module.iam.instance_profile
  ebs_root_volume_size = var.ebs_root_volume_size
  ec2_sg = module.sg.app_sg
  environment = var.environment
}


module "iam" {
  source = "./modules/iam"
  app_name = var.app_name
  ec2a_arn = module.ec2.ec2a_arn
}

module "s3" {
  source = "./modules/s3"
  app_name = var.app_name
  environment = var.environment
}

module "alb" {
  source = "./modules/alb"
  app_name = var.app_name
  bucket_name = module.s3.s3_bucket_id
  security_groups = module.sg.alb_sg
  alb_subnets = var.alb_subnets
  internal = var.internal
  ec2a_instance = module.ec2.ec2a_instance
  vpc_id = var.vpc_id
  name_initials = var.name_initials
}

module "r53" {
  source = "./modules/route53"
  dns_name = var.dns_name
  domain_name = var.domain_name
  elb_dns_name = module.alb.elb_dns_name
  elb_zone_id = module.alb.elb_zone_id
}