region                      = "us-east-1"
name                        = "muneeb-newrich"
muneeb_vpc_cidr_block       = "172.16.0.0/16"
wildcard_cidr               = "0.0.0.0/0"
availability_zone_01        = "us-east-1a"
availability_zone_02        = "us-east-1b"
ec2_key                     = "ci/cd"
image_id                    = "ami-08a52ddb321b32a8c"
instance_type               = "t2.micro"


prefix = {
  sub-1 = {
    az = "use1-az1"
    cidr = "172.16.1.0/24"

  }
  sub-2 = {
    az = "use1-az2"
    cidr = "172.16.2.0/24"
  }
}
prefixpri = {
  sub-1 = {
    az = "use1-az1"
    cidr = "172.16.3.0/24"

  }
  sub-2 = {
    az = "use1-az2"
    cidr = "172.16.4.0/24"
  }
}
