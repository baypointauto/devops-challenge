provider "aws" {
  region = "us-west-1"
}

# vpc
resource "aws_vpc" "gitlab_vpc" {
  cidr_block = "200.0.0.0/16"
  tags {
    Name = "gitlab_vpc"
  }
}

# gateway
resource "aws_internet_gateway" "gitlab_ig" {
  vpc_id = "${aws_vpc.gitlab_vpc.id}"
  tags {
    Name = "gitlab_ig"
  }
}

# public subnet
resource "aws_subnet" "gitlab_subnet" {
  vpc_id = "${aws_vpc.gitlab_vpc.id}"
  cidr_block = "200.0.0.0/24"
  availability_zone = "us-west-1b"
  tags {
    Name = "gitlab_subnet"
  }
}

# routing table for public subnet
resource "aws_route_table" "gitlab_rt" {
  vpc_id = "${aws_vpc.gitlab_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gitlab_ig.id}"
  }
  tags {
    Name = "gitlab_rt"
  }
}

# associate routing table to public subnet
resource "aws_route_table_association" "gitlab_subnet_rt" {
  subnet_id = "${aws_subnet.gitlab_subnet.id}"
  route_table_id = "${aws_route_table.gitlab_rt.id}"
}

# security group
resource "aws_security_group" "gitlab_sg" {
    name = "gitlab_sg"
    description = "public access security group"
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

    tags { 
       Name = "gitlab_sg"
     }
}
