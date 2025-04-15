resource "aws_instance" "web_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet_1.id
  security_groups = [aws_security_group.ec2_sg.id]

   user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl restart docker
              sudo systemctl enable docker
              sudo usermod -aG docker ec2-user
              

              docker run -d -p 8080:80 \
               -e OPENPROJECT_SECRET_KEY_BASE=someSecretKey \
               -e OPENPROJECT_HTTPS=false \
               openproject/openproject:15

EOF

  tags = { Name = "WebServer-Home" }
}

