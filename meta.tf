data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}

resource "aws_key_pair" "master" {
  key_name   = "kmz"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESr7RepHsk0YZ2ZzOlciHygJBv5NU/XxdRew5QRiOPi admin"
}

# Find the subnet that matches our DB CIDR
data "aws_subnet" "master" {
  filter {
    name   = "cidr-block"
    values = [var.subnet_cidr]
  }
}

