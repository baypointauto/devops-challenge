# DevOps Challenge
Solution by Forrest Jadick

### Application Endpoint
http://gitlab-elb-1078190902.us-west-1.elb.amazonaws.com/

### Login Credentials
- Username: adorwart
- Password: hBa=LbsJ5h

## Project Overview

**Components**
- Terraform
- Docker
- AWS
- GitLab

**Features**
- All infrastructure resources are configured as code (in terraform/)
- GitLab CI hosts are scaled via an Autoscaling Group and are balanced via an Elastic Load Balancer (ELB)
- CI runner instances are spun up and down by Docker Machine for super fast build processing

## Deployment Instructions

1. Clone this repo and cd to `terraform` directory
2. Run `terraform init`, then `terraform get && terraform apply -input=false -var-file=gitlab.tfvars`
3. Once deployment is complete, check newly created ELB in AWS console and confirm it has an InService instance. You should see 3 new VMs similar to these in the EC2 console:
![EC2 instances](https://github.com/baypointauto/devops-challenge/blob/master/images/ec2s.png)
4. Access GitLab application at ELB URL and create your admin password
5. SSH to Bastion server
6. Follow the instructions here to register the runner with GitLab and name the runner "runner":
    https://docs.gitlab.com/runner/register/index.html#gnu-linux
7. Run this command: `cp /etc/gitlab-runner/config.example /etc/gitlab-runner/config.toml` (replace existing)
8. Update the GitLab URL, runner token, AWS creds and VPC/subnet IDs in the config file here: `/etc/gitlab-runner/config.toml`
9. Run this command as root: `gitlab-runner run`
10. Confirm that a runner instance is running in the EC2 Console

## Scalability & Monitoring

- Scaling policies can easily be configured for the ASG to scale GitLab app instances according to demand.
- CI runner instances will scale as needed to satisfy the build's demands. No additional effort required once configured.
- CloudWatch can be configured to perform monitoring of the ASG.

## Possible Security Enhancements

- Use an IAM role instead of an account to grant AWS access to the bastion server (to spin up runner instances) so credentials don't have to be stored on the server.
- Update security group for GitLab instances to only allow inbound traffic from within the VPC. Disallow all other inbound traffic, including SSH. Use bastion server to SSH to instances.
- Put bastion server behind VPN.

## Hardware Testing Solution

I don't know how the hardware is tested currently, but I can imagine it's done using on-prem devices and hardware is likely hooked up via cabling or wireless connection. I will assume these machines run Linux. The issue likely then becomes one of allowing GitLab to execute testing code on the on-prem machine. GitLab must then receive feedback from the testing array based on the results.

If that's the case, then the testing code that's being executed from the runners can call scripts via SSH commands on the hardware testing machine or the testing server can poll a trigger file in S3 that's updated as part of a deployment (safer). When the file indicates a ready state, the scripts that need to be tested can be downloaded and excuted. Results can be uploaded to S3 or possibly sent to GitLab via an API request to either break or complete the build.
