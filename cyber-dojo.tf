variable "aws_key_path" {default = ""}
variable "aws_key_name" {default = ""}

provider "aws" {
  region     = "eu-central-1"
}

resource "aws_security_group_rule" "allow_http" {
    type            = "ingress"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.cyberdojo_security_group.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
    type            = "ingress"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.cyberdojo_security_group.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type            = "egress"
    from_port       = 10
    to_port         = 65000
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.cyberdojo_security_group.id}"
}

resource "aws_security_group" "cyberdojo_security_group" {
    name = "vpc_cyberdojo"
    description = "Allow incoming http and ssh connections."
}

data "aws_ami" "cyberdojo_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["cyber-dojo-*"]
  }

  owners     = ["self"]
}


data "template_file" "user_data" {
  template = "user_data.sh"
}

resource "aws_instance" "cyberdojo" {
  ami                         = "${data.aws_ami.cyberdojo_ami.image_id}" # ubuntu 16.04 LTS on eu-central
  instance_type               = "m4.large"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.cyberdojo_security_group.id}"]
  associate_public_ip_address = true

  user_data = "${file("user_data.sh")}"
}

output "cyberdojo_public_ip" {
 value = "${aws_instance.cyberdojo.public_ip}"
}
