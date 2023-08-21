variable "name" {
  default = "muneeb-newrich"
}
variable "vpc_id" {}
variable "ec2_key" {
  default = "ci/cd"
}
variable "image_id" {
  default = "ami-08a52ddb321b32a8c"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_id" {}
variable "prisubnet_id" {}
