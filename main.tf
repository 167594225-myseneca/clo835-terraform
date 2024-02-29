terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " ~> 3.27"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  access_key = "ASIA3SW6ZF2BYX3BQMX6"
  secret_key = "utD8r4Q0ixO5Q1kblBdoHsee92EcpIySKF8iQYRQ"
  token = "FwoGZXIvYXdzEDMaDCW4uUE4BKVquNEwTyLEARPnNzBtQHPVAvyO2V+LXyOz5xns1PyEWSvI34XwzqxJ5e0zj+N4ZPnlktYc+9Dt+ECFSkjQCFrhRO6Ojg2fROScvyy5cL7YhVudIHq5qt6OOtu/RqqiL1Mh+eXBDn/8tXXsFibj+y8loQMDiaamqsw8oSixn3kXvBmbuwwwCMCtPxepme3TVQsyv7bT3ZsetD3j5pt4w38ZI925yySFAu0hHNT1C4YYIDM0IZRKPnSszToR/5JO9/Nc4ZSQFwAqtTRvZYcox/KCrwYyLWJgsedqa6Gpj2s1+QbX4rRDxlLlA7alToyMcNPHTPj+KxMt0Jhtow/KTzaUJA=="
  profile    = "default"
  region     = "us-east-1"
}

###########################################################
########### RESOURCE BLOCKS ###############################
###########################################################

# Data source for AMI
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Data source to use the default VPC


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "clo835-host-kp" {
  key_name   = "assign02-kp"
  public_key = file("assign02-kp.pub")
}

# Security Group
resource "aws_security_group" "host-ec2-sg" {
  name = "security group from terraform"

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 from the internet"
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
}


# Step 12 - EC2 creation
resource "aws_instance" "clo835-host-EC2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.clo835-host-kp.key_name
  vpc_security_group_ids      = [aws_security_group.host-ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/ec2_init.sh")

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-host-EC2"
    }
  )
}


# ECR
resource "aws_ecr_repository" "clo835-ecr" {
  name                 = "jculloa-ecr"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
