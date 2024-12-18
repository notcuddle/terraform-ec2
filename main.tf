module "vpc" {
  source               = "./modules/vpc"
  name                 = "VPC-A"
  aws_region           = var.aws_region
  vpc_cidr_block       = var.vpc_cidr_block #"10.1.0.0/16"
  public_subnets_cidrs = [cidrsubnet(var.vpc_cidr_block, 8, 1)]
  enable_dns_hostnames = var.enable_dns_hostnames
  aws_azs              = var.aws_azs
}



module "web_server" {
  source        = "./modules/ec2"
  ami_linux     = var.ami_linux
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  vpc_id        = module.vpc.vpc_id
  ec2_name      = "Web Server"
}


module "cloud_front_ec2" {
  source         = "./modules/cloudFront"
  ec2_public_dns = module.web_server.ec2_public_dns
}