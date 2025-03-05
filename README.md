# Terraform Configuration for T-Pot EC2 Instance on AWS

This repository contains a Terraform configuration to provision an EC2 instance with a security group allowing specific IP addresses. It also installs the [T-Pot](https://github.com/telekom-security/tpotce) honeypot software on the instance using `user_data`.

## Prerequisites

- Terraform 0.12 or higher
- AWS account with appropriate credentials set up in the environment (via AWS CLI or environment variables)
- Key pair named `vockey` already created in the AWS region `us-east-1`

## Configuration Overview

This Terraform configuration does the following:

- Defines a variable `allowed_ip` to set the allowed IP address for accessing the EC2 instance.
- Creates a security group (`aws_security_group.tpot_sg`) that:
  - Allows TCP traffic from the `allowed_ip` on all ports (0-65535).
  - Allows unrestricted inbound TCP and UDP traffic on ports 1 to 64000.
  - Allows all outbound traffic.
- Provisions an EC2 instance (`aws_instance.tpot_terraform`) with:
  - The specified AMI (`ami-04b4f1a9cf54c11d0`).
  - Instance type `r5.large`.
  - `64GB` root block storage.
  - A `user_data` script to install T-Pot and set up the environment.

The output of the provisioning includes the EC2 instance's public IP.

## Usage

### 1. Initialize Terraform

Start by initializing Terraform to download the necessary provider plugins:

```bash
terraform init
2. Configure the allowed_ip Variable
The allowed_ip variable controls the IP address allowed to access the EC2 instance via the security group. You can set the default IP address in the variables.tf file.

The default value is 8.8.8.8/32, but you can customize it during the Terraform apply step.

3. Apply Terraform Configuration
You can either use the default IP or specify a different IP address by passing the allowed_ip variable during the apply step.

Example: Using Default IP
To apply the Terraform configuration with the default IP (8.8.8.8/32), run the following:

bash
Copy
Edit
terraform apply
Example: Customizing the Allowed IP
If you want to change the allowed IP address for accessing the EC2 instance, use the -var flag to specify a different IP:

bash
Copy
Edit
terraform apply -var="allowed_ip=192.168.1.100/32"
This command overrides the default allowed_ip value with 192.168.1.100/32, allowing only that IP to access the EC2 instance.

4. Output the Public IP
After the infrastructure is created, Terraform will output the public IP of the provisioned EC2 instance:

bash
Copy
Edit
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.tpot_terraform.public_ip
}
5. Destroy the Infrastructure
If you no longer need the resources, you can destroy them using the following command:

bash
Copy
Edit
terraform destroy
This will delete the EC2 instance and security group.

Example Output
bash
Copy
Edit
Outputs:

public_ip = "XX.XX.XX.XX"
Customizing Configuration
Change the Instance Type: Modify the instance_type attribute in the aws_instance resource.
Change the AMI: Update the ami attribute with the ID of the desired AMI.
Change the Security Group Rules: Modify the ingress and egress blocks in the aws_security_group resource to change the allowed ports or protocols.
License
This project is licensed under the MIT License - see the LICENSE file for details.
