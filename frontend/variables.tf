variable "region" {
  default = "us-east-2"
}

variable "name" {
  default = "muneeb-newrich"
}

variable "vpc_id" {}
variable "subnet_id" {}
variable "subnet2_id" {}
variable "availability_zone_01" {
  default = "us-east-1a"
}
variable "availability_zone_02" {
  default = "us-east-1b"
}

variable "ec2_key" {
  default = "ci/cd"
}
variable "image_id" {
  default = "ami-08a52ddb321b32a8c"
}

variable "instance_type" {
  default = "t2.micro"
}