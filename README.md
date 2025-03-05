# Terraform Configuration for T-Pot EC2 Instance on AWS

This repository contains a Terraform configuration to create an EC2 instance with the [T-Pot](https://github.com/telekom-security/tpotce) honeypot software, configured using `user_data`.

## Prerequisites

- Terraform;
- AWS account;
- Key pair named `vockey` already created in the AWS region `us-east-1`.

## Configuration Overview

This Terraform configuration does the following:

- Defines a variable `allowed_ip` to set the allowed IP address for accessing the EC2 instance.
- Creates a security group (`aws_security_group.tpot_sg`) that:
  - Allows TCP traffic from the `allowed_ip` on all ports (0-65535);
  - Allows unrestricted inbound TCP and UDP traffic on ports 1 to 64000;
  - Allows all outbound traffic.
- Provisions an EC2 instance (`aws_instance.tpot_terraform`) with:
  - The specified AMI (`ami-04b4f1a9cf54c11d0`);
  - Instance type `r5.large`;
  - `64GB` root block storage;
  - A `user_data` script to install T-Pot and set up the environment.

The output of the provisioning includes the EC2 instance's public IP.

## Usage

### 1. Clone this repository

Start by cloning this repository.

```bash
git clone https://github.com/jvieira9/tpot-terraform.git
```

```bash
cd tpot-terraform
```

### 2. Initialize Terraform

Initialize Terraform to download the necessary provider plugins:

```bash
terraform init
```
### 3. Apply Terraform Configuration

The allowed_ip variable controls the IP address allowed to access the EC2 instance via the security group. You can set the default IP address in the main.tf file or specify a different IP address by passing the allowed_ip variable during the apply step.

```bash
terraform apply -var="allowed_ip=192.168.0.2/32" -auto-approve
```

This command overrides the default allowed_ip value with 192.0.2.3/32.

After the infrastructure is created, Terraform will output the public IP of the provisioned EC2 instance:

Please note that, even after the instance is created, you should wait at least 15 for the instance to install and configure the honeypot.

### 4. Login

Once T-Pot is up and running, you can access its web interface through your browser:

**URL:**  
`https://<your-ec2-ip>:64297`

#### Login Credentials:

- **Username:** `jvieira`
- **Password:** `Passw0rd`


### 5. Destroy the Infrastructure
If you no longer need the resources, you can destroy them using the following command:

```bash
terraform destroy
```
This will delete the EC2 instance and security group.
