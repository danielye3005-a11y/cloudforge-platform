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

