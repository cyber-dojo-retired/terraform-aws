variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-central-1"
}

resource "aws_security_group" "cyberdojo-security-group" {
    name = "vpc_cyberdojo"
    description = "Allow incoming http and ssh connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # All outbound allowed - need to check this.
    egress {
        from_port = 10
        to_port = 65000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "cyberdojo" {
  ami                         = "ami-8504fdea" # ubuntu 16.04 LTS on eu-central
  instance_type               = "m4.large"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.cyberdojo-security-group.id}"]
  associate_public_ip_address = true

  provisioner "file" {
    connection {
          private_key = "${file("ssh/mykey.pem")}"
          user = "ubuntu"
          host = "${aws_instance.cyberdojo.public_ip}"
          timeout = "1m"
          agent = false
    }
    source = "setup.sh"
    destination = "/home/ubuntu/setup.sh"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.cyberdojo.private_ip} > private_ips.txt"
    command = "echo ${aws_instance.cyberdojo.public_ip} > public_ips.txt"
  }

  provisioner "remote-exec" {
        connection {
          private_key = "${file(var.aws_key_path)}"
          user = "ubuntu"
          host = "${aws_instance.cyberdojo.public_ip}"
          timeout = "1m"
          agent = false
        }
        inline = [
          "echo hello, ",
          "hostname"
        ]
    }
  provisioner "remote-exec" {
        connection {
          private_key = "${file(var.aws_key_path)}"
          user = "ubuntu"
          host = "${aws_instance.cyberdojo.public_ip}"
          timeout = "1m"
          agent = false
        }
        script = "setup.sh"
    }
}
