provider "aws" {
  region = "us-east-1"
}

variable "allowed_ip" {
  description = "IP address allowed to access the security group"
  type = string
  default = "192.0.2.2/32"  # You can change this default IP as needed
}

resource "aws_security_group" "tpot_sg" {
  name = "tpot_terraform_sg"
  description = "Security group for T-Pot EC2 instance"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  ingress {
    from_port = 1
    to_port = 64000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1
    to_port = 64000
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tpot_terraform" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "r5.large"
  key_name = "vockey"
  security_groups = [aws_security_group.tpot_sg.name]

  root_block_device {
    volume_size = 64
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "Terraform T-Pot"
  }
  user_data = <<-EOF
      #!/bin/bash
      apt update && apt upgrade -y
      apt install -y git
      cd /home/ubuntu
      git clone https://github.com/telekom-security/tpotce
      cd tpotce
      chown -R ubuntu:ubuntu /home/ubuntu/tpotce
      sudo -u ubuntu bash -c "echo -e 'y\nh\njvieira\ny\nPassw0rd\nPassw0rd\ny' | ./install.sh >> /home/ubuntu/tpotce/tf_tpot.log 2>&1"
      sleep 60
      reboot now
      EOF
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value = aws_instance.tpot_terraform.public_ip
}
