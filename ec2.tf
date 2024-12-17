# Create a new SSH keypair
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Ensure you have your public key generated, or use an empty string to auto-generate one
}

# Create a new security group
resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Allow SSH and HTTP access"

  # Allow SSH access (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance and use the SSH keypair and security group
resource "aws_instance" "ubuntu_server" {
  ami             = "ami-0e2c8caa4b6378d8c"  # Ubuntu Server 24.04 LTS AMI for us-east-1, adjust if needed
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "DevOps Server"
  }

  # User Data for provisioning the instance with Nginx and user setup
  user_data = <<-EOT
              #!/bin/bash
              # Update and install packages
              apt-get update -y
              apt-get install -y nginx sudo

              # Create devops user and give sudo privileges
              useradd -m devops
              echo "devops:devops123" | chpasswd
              usermod -aG sudo devops

              # Create a static HTML page for Nginx
              mkdir -p /var/www/html/devops-site
              echo '<html><head><title>DevOps Page</title></head><body><h1>Welcome to the DevOps Page!</h1><p>This is a static page served by Nginx.</p></body></html>' > /var/www/html/devops-site/index.html

              # Update Nginx configuration
              echo 'server {
                listen 80;
                root /var/www/html/devops-site;
                index index.html;
                server_name _;

                location / {
                  try_files $uri $uri/ =404;
                }
              }' > /etc/nginx/sites-available/devops-site

              # Enable the site and restart Nginx
              ln -s /etc/nginx/sites-available/devops-site /etc/nginx/sites-enabled/
              systemctl restart nginx
              EOT

  # Allow HTTP traffic on port 80 (Security Group)
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_server.public_ip
}

output "key_name" {
  value = aws_key_pair.devops_key.key_name
}

output "security_group_id" {
  value = aws_security_group.devops_sg.id
}
