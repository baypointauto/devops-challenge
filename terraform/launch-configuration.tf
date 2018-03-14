resource "aws_launch_configuration" "gitlab_lc" {
    name = "gitlab_lc"
    image_id = "ami-67120707"
    instance_type = "t2.medium"

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups = ["${aws_security_group.gitlab_sg.id}"]
    associate_public_ip_address = "true"
    key_name = "gitlab"
}
