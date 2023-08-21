#1. Bastion Host Security Group
resource "aws_security_group" "muneeb_bastion_sg" {
    name        = "${var.name}-bastion-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-bastion_sg"
    }
}
#2. Private EC2 instance Security Group
resource "aws_security_group" "muneeb_private_sg" {
    name        = "${var.name}-private-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = ["${aws_security_group.muneeb_bastion_sg.id}"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-private_sg"
    }
}

#3. Create Bastion Host
resource "aws_instance" "bastion_host" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.ec2_key 
  vpc_security_group_ids      = [aws_security_group.muneeb_bastion_sg.id] 
  subnet_id                   = var.subnet_id 
  associate_public_ip_address = "true"
  tags = {
    Name                      = var.name
  }
}

#3. Create Private EC2 instance
resource "aws_instance" "private_instance" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.ec2_key 
  vpc_security_group_ids      = [aws_security_group.muneeb_private_sg.id] 
  subnet_id                   = var.prisubnet_id 
  associate_public_ip_address = "true"
  tags = {
    Name                      = var.name
  }
}