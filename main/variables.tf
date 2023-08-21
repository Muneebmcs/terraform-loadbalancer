
variable "name" {
  default = "muneeb-newrich"
}

variable "muneeb_vpc_cidr_block" {
  default = "172.16.0.0/16"
}
variable "wildcard_cidr" {
  default = "0.0.0.0/0"
}


variable "availability_zone_01" {
  default = "us-east-1a"
}
variable "availability_zone_02" {
  default = "us-east-1b"
}
variable "region" {
  default = "us-east-1"
}

variable "ec2_key" {
  default = "ci/cd"
}

variable "prefix" {
   type = map
   default = {
      sub-1 = {
         az = "use1-az1"
         cidr = "172.16.1.0/24"
      }
      sub-2 = {
         az = "use1-az2"
         cidr = "172.16.2.0/24"
      }
   }
}
variable "image_id" {
  default = "ami-08a52ddb321b32a8c"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "prefixpri" {
   type = map
   default = {
      sub-1 = {
         az = "use1-az1"
         cidr = "172.16.3.0/24"
      }
      sub-2 = {
         az = "use1-az2"
         cidr = "172.16.4.0/24"
      }
   }
}