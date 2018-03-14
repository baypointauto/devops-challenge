# DevOps Challenge
Solution by Forrest Jadick

### Application Endpoint
http://gitlab-elb-1078190902.us-west-1.elb.amazonaws.com/

### Login Credentials
- Username: adorwart
- Password: hBa=LbsJ5h

## Project Overview

### Architecture

**Main Components**
- Terraform
- Docker
- AWS

**Features**
- All infrastructure resources are configured as code (in terraform/)
- GitLab CI hosts are scaled via Autoscaling Group behind an Elastic Load Balancer (ELB)
- CI Runners are scaled automatically by Docker
- Bastion server which orchestrates CI runners

# Deployment Instructions

NOTE: AMI for bastion for deployment are in my account and private. These instructions cannot be reproduced without those AMIs.

1. Check out this repo and cd to `terraform` directory
2. Run `terraform init`, then `terraform get && terraform apply -input=false -var-file=gitlab.tfvars`
3. Once deployment is complete, check newly created ELB in AWS console and confirm it has an InService instance
4. Access GitLab application at DNS endpoint URL
5. SSH to Bastion server
6. Edit the this config file as root: `/etc/gitlab-runner/config.toml`
7.
