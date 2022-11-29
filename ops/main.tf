terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}


resource "aws_instance" "app_server" {
  ami                    = "ami-017fecd1353bcc96e"
  instance_type          = "t2.micro"
  key_name               = "appkey"
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.http.id]
  subnet_id              = aws_subnet.main.id
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker ubuntu

sudo apt update
sudo apt install -y docker-compose
EOF
}

# this shows the old address :/
# output "app_server_public_dns" {
#   value = aws_instance.app_server.public_dns
# }

resource "random_integer" "cidr_seed" {
  min = 0
  max = 2047
}

resource "aws_vpc" "main" {
  cidr_block = cidrsubnet("172.16.0.0/12", 11, random_integer.cidr_seed.result)
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 2, 0)
  availability_zone = "us-west-2a"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "ssh" {
  name        = "ssh-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

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
}

resource "aws_security_group" "http" {
  name        = "http-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

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
}

resource "aws_eip" "main" {
  vpc = true
  instance = aws_instance.app_server.id
}

# ALB (second ec2 instance)
# TODO

# CloudWatch
# TODO