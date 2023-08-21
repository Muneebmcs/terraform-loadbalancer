#1. Create VPC
resource "aws_vpc" "muneeb_vpc" {
    cidr_block = var.muneeb_vpc_cidr_block
    tags = {
        Name = "${var.name}-vpc"
    }
}
#2. Create Internet gateway
resource "aws_internet_gateway" "muneeb_igw" {
    vpc_id = aws_vpc.muneeb_vpc.id
    tags = {
      Name = "${var.name}-igw"
    }
}
#3. Create Public Route Table
resource "aws_route_table" "muneeb_pub_route_table" {
    vpc_id = aws_vpc.muneeb_vpc.id
    tags = {
      Name = "${var.name}-pub_route_table"
    }
    route {
        cidr_block = var.wildcard_cidr
        gateway_id = aws_internet_gateway.muneeb_igw.id
    }
  
}
#4. Create Public Subnet
resource "aws_subnet" "public-subnet" {
  for_each = var.prefix
 
  availability_zone_id = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.muneeb_vpc.id     
  tags = {
    Name = "${var.name}-${each.value["az"]}"
 }
}

#5. Associate Subnet with Route Table
resource "aws_route_table_association" "muneeb_route_table_association" {
  for_each = {
    for k, v in aws_subnet.public-subnet : k => v
    }
    subnet_id = each.value.id
    route_table_id = aws_route_table.muneeb_pub_route_table.id
}


#6. OUtput variables
output "vpc_id" {
  value = "${aws_vpc.muneeb_vpc.id}"
}

  output "subnet_id" {
   value = "${aws_subnet.public-subnet["sub-1"].id}"
  }

  output "subnet2_id" {
   value = "${aws_subnet.public-subnet["sub-2"].id}"
  }
  output "prisubnet_id" {
   value = "${aws_subnet.pri-subnet["sub-1"].id}"
  }


#7. Create elastic ip address
resource "aws_eip" "muneeb_eip" {
  vpc      = true
  tags = {
    Name = "${var.name}-eip"
}
}
#8. Create NAT gateway
resource "aws_nat_gateway" "muneeb_nat_gateway" {
  allocation_id = aws_eip.muneeb_eip.id
  subnet_id      = aws_subnet.public-subnet["sub-1"].id

  tags = {
    Name = "${var.name}-muneeb-nat-gateway"
}
  depends_on = [aws_internet_gateway.muneeb_igw]
}
#9. Create Private Route Table
resource "aws_route_table" "muneeb_pri_route_table" {
    vpc_id = aws_vpc.muneeb_vpc.id
    tags = {
      Name = "${var.name}-pri_route_table"
    }
    route {
        cidr_block = var.wildcard_cidr
        gateway_id = aws_nat_gateway.muneeb_nat_gateway.id
    }
}
#10. Create Private Subnet
resource "aws_subnet" "pri-subnet" {
  for_each = var.prefixpri
 
  availability_zone_id = each.value["az"]
  cidr_block = each.value["cidr"]
  vpc_id     = aws_vpc.muneeb_vpc.id     
  tags = {
    Name = "${var.name}-${each.value["az"]}"
 }
}


#11. Associate Subnet with Private Route Table
resource "aws_route_table_association" "muneeb_route_table_association_pri" {
  for_each = {
    for k, v in aws_subnet.pri-subnet : k => v
    }
    subnet_id = each.value.id
    route_table_id = aws_route_table.muneeb_pri_route_table.id
}

