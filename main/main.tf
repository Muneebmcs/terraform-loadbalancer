## Configure the AWS provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>4.0"
    }
  }
}

provider "aws" {
    region = var.region
    shared_credentials_files = ["C:/Users/muneeburrehman/.aws/credentials"]
}
module "vpc" {
  
    source                          = "../vpc"
    name                            = var.name
    muneeb_vpc_cidr_block           = var.muneeb_vpc_cidr_block
    wildcard_cidr                   = var.wildcard_cidr
    availability_zone_01            = var.availability_zone_01
    availability_zone_02            = var.availability_zone_02  
    prefix                          = var.prefix
    prefixpri                       = var.prefixpri 
    

}  
module "frontend" {
  
    source                          = "../frontend"
    name                            = var.name
    vpc_id                          = "${module.vpc.vpc_id}"
    availability_zone_01            = var.availability_zone_01
    availability_zone_02            = var.availability_zone_02
    subnet_id                       = "${module.vpc.subnet_id}"
    subnet2_id                      = "${module.vpc.subnet2_id}"
    ec2_key                         = var.ec2_key
    image_id                        = var.image_id
    instance_type                   = var.instance_type 
    
} 