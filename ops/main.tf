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
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  key_name = aws_key_pair.app_key.key_name

  user_data = <<EOF
#!/bin/bash

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

docker run hello-world
EOF
}

resource "aws_key_pair" "app_key" {
    key_name   = "app_key"
    public_key = tls_private_key.rsa_key.public_key_openssh
}

resource "tls_private_key" "rsa_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "local_file" "private_key" {
    filename = "app_key"
    content  = tls_private_key.rsa_key.private_key_pem
}