resource "aws_security_group" "web_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22       
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80       
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }


  tags = {
    Name = "servidor-web-sg"
  }
}


resource "aws_instance" "web" {
  ami                    = var.ami_linux
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  instanceAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
  pubHostName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
  pubIPv4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
  privHostName=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
  privIPv4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
  
  echo "<font face = "Verdana" size = "5">"                               > /var/www/html/index.html
  echo "<center><h1>AWS Linux VM Deployed with Terraform</h1></center>"   >> /var/www/html/index.html
  echo "<center> <b>EC2 Instance Metadata</b> </center>"                  >> /var/www/html/index.html
  echo "<center> <b>Instance ID:</b> $instanceId </center>"                      >> /var/www/html/index.html
  echo "<center> <b>AWS Availablity Zone:</b> $instanceAZ </center>"             >> /var/www/html/index.html
  echo "<center> <b>Public Hostname:</b> $pubHostName </center>"                 >> /var/www/html/index.html
  echo "<center> <b>Public IPv4:</b> $pubIPv4 </center>"                         >> /var/www/html/index.html
  echo "<center> <b>Private Hostname:</b> $privHostName </center>"               >> /var/www/html/index.html
  echo "<center> <b>Private IPv4:</b> $privIPv4 </center>"                       >> /var/www/html/index.html
  echo "</font>"                                                          >> /var/www/html/index.html
EOF

  tags = {
    Name = "web-server-nginx"
    Team = "DevOps"
  }
}