provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "af-ec2" {
  for_each = { for idx, name in local.instance_names : idx => name }

  ami           = "ami-08602ac2d592c8c31" # ubuntu server 22.04
  instance_type = var.instance_type
  key_name = each.value

  tags = {
    Name = each.value
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
}

resource "aws_security_group" "instance_security_group" {
  name        = "devops-security-group"
  description = "Allow SSH, HTTP, and HTTPS traffic"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}