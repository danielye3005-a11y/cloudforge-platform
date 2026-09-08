resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  description = "Allow HTTP traffic from the internet"
}

terraform {

  required_version = ">= 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "cloudforge" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloudforge-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.cloudforge.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cloudforge-public-subnet-1"
  }
}

resource "aws_internet_gateway" "cloudforge" {
  vpc_id = aws_vpc.cloudforge.id

  tags = {
    Name = "cloudforge-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudforge.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudforge.id
  }

  tags = {
    Name = "cloudforge-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.cloudforge.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "cloudforge-private-subnet-1"
  }
}

resource "aws_security_group" "alb" {
  name        = "cloudforge-alb-sg"
  description = "Security group for the CloudForge Application Load Balancer"
  vpc_id      = aws_vpc.cloudforge.id

  tags = {
    Name = "cloudforge-alb-sg"
  }
}



resource "aws_security_group" "app" {
  name        = "cloudforge-app-sg"
  description = "Security group for the CloudForge application"
  vpc_id      = aws_vpc.cloudforge.id

  tags = {
    Name = "cloudforge-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id = aws_security_group.app.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000

  description = "Allow application traffic only from the ALB"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id = aws_security_group.alb.id

  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000

  description = "Allow ALB traffic to the application"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.app.id]

  tags = {
    Name = "cloudforge-app"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "cloudforge-app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudforge.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "5000"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "cloudforge-app-tg"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.cloudforge.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "cloudforge-public-subnet-2"
  }
}

resource "aws_lb" "app" {
  name               = "cloudforge-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  tags = {
    Name = "cloudforge-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
