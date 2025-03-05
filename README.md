# Terraform T-Pot EC2 Instance

This repository contains a Terraform configuration to set up an AWS EC2 instance running the T-Pot honeypot system. The script automatically provisions an EC2 instance, configures the necessary security groups, and installs T-Pot using a custom user-data script.

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) with proper IAM permissions
- An existing AWS key pair (`vockey`) to access the instance

## Project Structure

- `main.tf`: Terraform configuration to create resources on AWS
- `tpotce`: GitHub repository for T-Pot honeypot system (automatically cloned during EC2 instance setup)

## Configuration

### `main.tf`

The configuration includes the following resources:

1. **AWS Security Group**: 
   - Allows inbound traffic on specific ports (TCP & UDP) from the internet and a specific IP address.
   - Outbound traffic is allowed to all destinations.

2. **AWS EC2 Instance**:
   - Instance type: `r5.large`
   - AMI: `ami-04b4f1a9cf54c11d0` (Ubuntu-based image)
   - Security group: Uses the defined `tpot_terraform_sg`
   - Storage: 64GB (`gp2`) root volume, deleted upon termination
   - Key pair: `vockey`

3. **User Data Script**:
   - Updates and upgrades the system
   - Installs Git
   - Clones the T-Pot repository
   - Configures the necessary permissions and runs the T-Pot installation script
   - Logs the output to `/home/ubuntu/tpotce/tf_tpot.log`
   - Reboots the system after installation

## How to Use

### 1. Initialize Terraform

Before applying the configuration, initialize Terraform:

```bash
terraform init
