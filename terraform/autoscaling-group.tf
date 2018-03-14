resource "aws_autoscaling_group" "gitlab_asg" {
	availability_zones = ["us-east-1b", "us-east-1c"]
    	name = "gitlab_asg"
    	max_size = 3
    	min_size = 1
    	desired_capacity = 1
	health_check_type = "ELB"
    	vpc_zone_identifier = ["${aws_subnet.gitlab_subnet.id}"]
    	launch_configuration = "${aws_launch_configuration.gitlab_lc.name}"
    	health_check_type = "ELB"
	
	tag {
		key = "app"
		value = "gitlab"
		propagate_at_launch = true
}}
