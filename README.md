# DevOps Challenge
Solution by Forrest Jadick

### Application Endpoint
http://gitlab-elb-1078190902.us-west-1.elb.amazonaws.com/

### Login Credentials
- Username: adorwart
- Password: hBa=LbsJ5h

## Project Overview

**Architecture**
- Terraform
- Docker
- AWS

**Features**
- All infrastructure resources are configured as code (in terraform/)
- GitLab CI hosts are scaled via Autoscaling Group behind an Elastic Load Balancer (ELB)
- CI Runners are scaled automatically by Docker
- A Bastion server which orchestrates CI runners

## Deployment Instructions

**NOTE:** For security reasons, the AMI for the bastion instance is not public. If you would like to use it, please email me and I will grant your account access.

1. Check out this repo and cd to `terraform` directory
2. Run `terraform init`, then `terraform get && terraform apply -input=false -var-file=gitlab.tfvars`
3. Once deployment is complete, check newly created ELB in AWS console and confirm it has an InService instance
4. Access GitLab application at DNS endpoint URL
5. SSH to Bastion server
6. Edit the this config file as root: `/etc/gitlab-runner/config.toml`
7. Update the GitLab and VPC/subnet IDs in the config file
8. Run this command as root: `gitlab-runner run`
9. Confirm that a runner instance is running in the EC2 Console

## Possible Security Enhancements

- Use an IAM role instead of an account to grant AWS access to the bastion server (to spin up CI runners) so credentials don't have to be stored on the server.
- Update security group for GitLab instances to only allow inbound traffic from VPC CIDR block. Disallow all outside inbound traffic.
