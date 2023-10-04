#######################################################
################### Start - AWS EC2 ###################
#######################################################
# Creating Key Pair values
resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDh5OfTWfL2m2O4tBhtGMvGHDC3BrYeiNx1n2Ot4UwBCLEpXpq1nHU9Fq1hf0/CvR85NbJhHjDaMDdjEQ1TT6OCUsfkhT+T1ojyq3gSUW6Nhm5nxXwo/HLYaZtywYMJeHsoxBfmFWBVWezCh/iwnkl8lwByI4J3T7OxxAuM9zW+4R4ZKL+AoQmSDZlS2bLkjzLAAlV/FKYsqWFjw4NVPJpcF2DKgcdZrYdxYjWAC/QrtW7ORX6Gg+/HfhUl4vtA/5CMBh/PcQ34wdTJtlZ/MMhHMPMEoXn1prZ0oG0kt20owD1a+mqaHj9dU0QHjIN9bX5gGnTDe/JklvvfDiUXHD3UFupo1cfI3RWnpn3FrKhXtGrum3EgG8brkwjVD403Q9UhVWkTIHaePJJq+r62tSE/xhzpzpDlc5oucVqQtfOzsjO3mp8r9DDLeA0ahidXMY5SC3Yr7MbvM73nR838jmt++HKFV+jDBtw0mM85hcVZPUa4cBcdhzgm2olSVdstbE= service_terraform_enterprise"
}

resource "aws_instance" "tokyo-web" {
  ami             = var.ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.tokyo-frontend-securitygroup.id]
  subnet_id       = aws_subnet.tokyo-frontend-subnet[0].id
  key_name        = var.key_name

  # Run install-httpd.sh script
  user_data = file("bootstrap.sh")

  #!/bin/bash
  # Use this for your user data (script from top to bottom)
  # install httpd (Linux 2 version)
  #sudo yum update -y
  #sudo yum install -y httpd
  #sudo systemctl start httpd
  #sudo systemctl enable httpd
  #echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  #      EOF
  tags = {
    Name = "Web Server"
    Role = "frontend"
  }
}

resource "aws_instance" "tokyo-backend" {
  ami             = var.ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.tokyo-backend-securitygroup.id]
  subnet_id       = aws_subnet.tokyo-backend-subnet[0].id
  key_name        = var.key_name

  # Run install-node.sh script, provided in scripts sub-folder, at EC2 instance launch time
  user_data = file("scripts/install-node.sh")
  tags = {
    Name = "Backend Server"
    Role = "backend"
  }
}

#####################################################
################### End - AWS EC2 ###################
#####################################################
