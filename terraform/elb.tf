# ELB
resource "aws_elb" "gitlab-elb" {
	name = "gitlab-elb"
	subnets = ["${aws_subnet.gitlab_subnet.id}"]
	internal = "false"
	security_groups = ["${aws_security_group.gitlab_sg.id}"]
	
	listener {
		instance_port = 80
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}
}
