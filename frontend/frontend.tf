#1. Frontend Security Group
resource "aws_security_group" "muneeb_web_sg" {
    name        = "${var.name}-web-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = ["${aws_security_group.muneeb_lb_sg.id}"]
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-web_sg"
    }
}
#2. Load Balancer Security Group
resource "aws_security_group" "muneeb_lb_sg" {
    name        = "${var.name}-lb-sg"
    description = "muneeb-lb-sg"
    vpc_id      = var.vpc_id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
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
        Name = "${var.name}-lb_sg"
    }
}

#3. Target Group
 resource "aws_lb_target_group" "muneeb_lb_target_group" {
  name     = "muneeb-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
      Name = "${var.name}-lb-target-group"
    }  
  
}

#4. Load Balancer
resource "aws_alb" "muneeb_alb" {
  name            = "muneeb-alb"
  security_groups = [aws_security_group.muneeb_lb_sg.id]
  subnets         = [var.subnet_id , var.subnet2_id ]
  tags = {
      Name = "${var.name}-alb"
  }
}
resource "aws_lb_listener" "muneeb-listener" {
  load_balancer_arn = aws_alb.muneeb_alb.arn
  port              = "80"
  default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.muneeb_lb_target_group.arn
  }
}


#5. Launch Configuration
resource "aws_launch_configuration" "muneeb_web_server_1_lc" {
  name          = "muneeb-web-server-1-lc"
  image_id      = var.image_id
  instance_type = var.instance_type
  security_groups   = [aws_security_group.muneeb_web_sg.id]
  key_name          = var.ec2_key
  associate_public_ip_address = "true"
  user_data = <<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum -y install httpd
                sudo yum -y install ruby
                wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
                chmod +x install
                ./install auto
                service codedeploy-agent status
                systemctl start httpd
                cd /var/www/html
                echo "Muneeb-website" >> /var/www/html/index.html
                EOF
  }
#6.Autoscaling Group
resource "aws_autoscaling_group" "muneeb_asg_1" {
  name                      = "muneeb-asg-1"
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.muneeb_web_server_1_lc.id
  vpc_zone_identifier       = [var.subnet_id]
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.muneeb_lb_target_group.arn]
  
}

resource "aws_autoscaling_policy" "muneeb_autoscaling_policy_asg1" {
  name                   = "muneeb-autoscaling-policy-asg-1"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.muneeb_asg_1.name
}

#7. Cloudwatch Alarm
resource "aws_cloudwatch_metric_alarm" "muneeb_cloudwatch_metric_alarm_asg1" {
  alarm_name                = "muneeb-cloudwatch-metric-alarm-asg1"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.muneeb_asg_1.name
  }

  alarm_actions     = [aws_autoscaling_policy.muneeb_autoscaling_policy_asg1.arn]
}

#8. Create Reverse proxy security group
resource "aws_security_group" "muneeb_reverseproxy_sg" {
    name        = "${var.name}-reverseproxy-sg"
    vpc_id      = var.vpc_id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-reverseproxy_sg"
    }
}

#9. Create reverse proxy server
resource "aws_instance" "eks_reverseproxy" {
  ami                         = var.image_id
  instance_type               = var.instance_type
  key_name                    = var.ec2_key 
  vpc_security_group_ids      = [aws_security_group.muneeb_reverseproxy_sg.id] 
  subnet_id                   = var.subnet_id 
  associate_public_ip_address = "true"
  tags = {
    Name                      = var.name
  }
}
#9. Output Variables
output "sg_id" {
  value = "${aws_security_group.muneeb_web_sg.id}"
}

