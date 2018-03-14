# bastion security group
resource "aws_security_group" "bastion_sg" {
   name = "bastion_sg"
   description = "bastion security group"	
   vpc_id = "${aws_vpc.gitlab_vpc.id}"

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
}

# bastion instance (ubuntu)
resource "aws_instance" "bastion" {
  ami = "ami-05312565"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  subnet_id = "${aws_subnet.gitlab_subnet.id}"
  key_name = "bastion"

  tags {
    Name = "bastion"
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}
