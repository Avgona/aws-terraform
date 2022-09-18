provider "aws" {
  access_key = "null"
  secret_key = "null"
  region     = "us-east-2"
}

data "aws_availability_zones" "availability" {}
data "aws_region" "region" {}
data "aws_ami" "latest_ubuntu_ami_id" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.latest_ubuntu_ami_id.id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-2c"
  vpc_security_group_ids = [aws_security_group.ubuntu_security_group.id]
  user_data              = <<EOF
        #!/bin/bash
        yum -u update
        yum -u install httpd
        myip='curl http://169.254.169.254/latest/meta-data/local-ipv4'
        echo "<h2>WebServer with IP: $myip</h2><br> Build by Terraform!" > /var/www/html/index.html
        sudo service httpd start
        chkconfig httpd on
  EOF

  lifecycle {
    create_before_destroy = yes
  }
}


resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "ubuntu_security_group" {
  name        = "WebServer Security Group"
  description = "My security group"
  vpc_id      = aws_default_vpc.default_vpc.id
  ingress {
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

