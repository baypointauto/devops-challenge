# DevOps Challenge
Solution by Forrest Jadick

### Application Endpoint
http://gitlab-elb-1078190902.us-west-1.elb.amazonaws.com/

### Login Credentials
- Username: adorwart
- Password: hBa=LbsJ5h

## Project Overview

### Architecture

_Main Components_
- Terraform
- Docker
- AWS

*Features*
- All infrastructure resources are configured as code (in terraform/)
- GitLab CI hosts are scaled via Autoscaling Group behind an Elastic Load Balancer (ELB)
- CI Runners are scaled automatically via Docker
