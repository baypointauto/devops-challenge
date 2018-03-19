# DevOps Challenge
Solution by Forrest Jadick

### Application Endpoint
http://gitlab-elb-1078190902.us-west-1.elb.amazonaws.com/ (offline)

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
- GitLab CI hosts are scaled via an Autoscaling Group and are load balanced via an Elastic Load Balancer (ELB)
- CI runner instances are spun up and down by Docker Machine for super fast build processing

## Deployment Instructions

First, create two key pairs in the EC2 Console. One called `gitlab` and another called `bastion`. Save the private keys.

Then: 

1. On a machine with Terraform and AWS CLI installed, clone this repo and cd to `terraform` directory
2. Run `terraform init`, then `terraform get && terraform apply -input=false -var-file=gitlab.tfvars`
3. Once deployment is complete, check newly created ELB in AWS console and confirm it has an InService instance (you might have to manually add the instance when the ASG is initially spun up).
4. Access GitLab application at ELB URL and create your admin password
5. SSH to Bastion server
6. Follow the instructions here to register the runner with GitLab. For the description, use "runner".
    https://docs.gitlab.com/runner/register/index.html#gnu-linux
7. Run this command: `cp /etc/gitlab-runner/config.example /etc/gitlab-runner/config.toml` (replace existing)
8. Update the GitLab URL, runner token, AWS creds and VPC/subnet IDs in the config file here: `/etc/gitlab-runner/config.toml`
9. Run this command as root: `gitlab-runner run`
10. Confirm that a runner instance is present in the EC2 Console. You should see 3 instances similar to these:
![EC2 instances](https://github.com/baypointauto/devops-challenge/blob/master/images/ec2s.png) If so, deployment is complete!

## Scalability & Monitoring

- Scaling policies can easily be configured for the ASG to scale GitLab app instances according to demand.
- CI runner instances will scale as needed to satisfy the build's demands. No additional effort required once configured.
- CloudWatch can be configured to perform monitoring of the ASG.

## Possible Security Enhancements

- Enable port 443 on the ELB security group, add 443 to as a listener to the ELB and assign a certificate. Only allow traffic over port 443 to secure the connection to the GitLab app.
- Use an IAM role instead of an account to grant AWS access to the Bastion server (to spin up runner instances) so credentials don't have to be stored on the server.
- Update security group for GitLab instances to only allow inbound traffic from within the VPC. Disallow all other inbound traffic, including SSH. Use Bastion server to SSH to instances.
- Put Bastion server behind VPN.

## Hardware Testing Solution

I don't know how the hardware is tested currently, but I can imagine it's done using on-prem devices. Hardware is likely hooked up via cabling or wireless connection. I will assume these machines run Linux. The issue likely then becomes one of allowing GitLab to execute testing code on the on-prem machine (Hybrid Cloud). GitLab must then receive feedback from the testing array based on the results.

If that's the case, then the testing code that's being executed from the runners can call scripts via SSH commands on the hardware testing machine or the testing server can poll a trigger file in S3 that's updated as part of a deployment (safer). When the file indicates a ready state, the scripts that need to be tested can be downloaded and excuted. Results can be uploaded to S3 or possibly sent to GitLab via an API request to either break or complete the build.
