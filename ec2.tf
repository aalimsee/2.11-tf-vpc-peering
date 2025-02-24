
locals {
  ami = "ami-05b10e08d247fb927"
  instance_type = "t2.micro"
  user_data_def_1 = "VPC-1"
  user_data_def_2 = "VPC-2"
}

# Create EC2 in VPC 1
resource "aws_instance" "ec2_vpc1" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id     = aws_subnet.subnet_vpc1.id
  vpc_security_group_ids = [aws_security_group.vpc1_ssh_sg.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens                 = "optional" # Allows both IMDSv1 and IMDSv2
    http_endpoint               = "enabled"  # Enables access to the metadata service
    http_put_response_hop_limit = 2          # Optional, sets the hop limit for metadata requests
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from Application EC2 (${local.user_data_def_1}), Aaron Lim</h1>" | sudo tee /var/www/html/index.html
    echo "<h1>Instance $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1>" | sudo tee -a /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF
  )
  tags = {
    Name = "${var.prefix}-EC2-VPC1"
  }
}

# Create EC2 in VPC 2
resource "aws_instance" "ec2_vpc2" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id     = aws_subnet.subnet_vpc2.id
  vpc_security_group_ids = [aws_security_group.vpc2_ssh_sg.id]
  associate_public_ip_address = true

  metadata_options {
    http_tokens                 = "optional" # Allows both IMDSv1 and IMDSv2
    http_endpoint               = "enabled"  # Enables access to the metadata service
    http_put_response_hop_limit = 2          # Optional, sets the hop limit for metadata requests
  }
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from Application EC2 (${local.user_data_def_2}), Aaron Lim</h1>" | sudo tee /var/www/html/index.html
    echo "<h1>Instance $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</h1>" | sudo tee -a /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF
  )
  tags = {
    Name = "${var.prefix}-EC2-VPC2"
  }
}