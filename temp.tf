resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_security_group"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (adjust for better security)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS (Jenkins) from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

resource "aws_ebs_volume" "jenkins_volume" {
  availability_zone = aws_instance.jenkins_instance.availability_zone
  size              = 5
  tags = {
    Name = "Jenkins-Data-Volume"
  }
}

resource "aws_volume_attachment" "jenkins_attachment" {
  device_name  = "/dev/xvdf"
  volume_id    = aws_ebs_volume.jenkins_volume.id
  instance_id  = aws_instance.jenkins_instance.id
  force_detach = true
}

resource "aws_key_pair" "ssh_pub" {
  key_name = "ssh_pub-key"
  public_key = file("technion-key.pub")
}

resource "aws_instance" "jenkins_instance" {
  ami                    = "ami-0d5eff06f840b45e9"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.ssh_pub.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              # Mount EBS volume
              mkfs -t ext4 /dev/xvdf
              mkdir -p /var/jenkins_home
              mount /dev/xvdf /var/jenkins_home
              echo "/dev/xvdf /var/jenkins_home ext4 defaults,nofail 0 2" >> /etc/fstab
              
              # Install Jenkins
              docker run -d -p 443:8080 -p 50000:50000 --name jenkins \
                -v /var/jenkins_home:/var/jenkins_home \
                -v /var/jenkins_home/config:/var/jenkins_home/config \
                jenkins/jenkins:lts
              EOF

  tags = {
    Name = "Jenkins-Docker-Server"
  }
}

resource "local_file" "jenkins_config" {
  content  = <<-EOC
    jenkins:
      systemMessage: "Welcome to my Jenkins CI/CD Server"
      numExecutors: 4
      securityRealm:
        local:
          allowsSignup: false
      authorizationStrategy:
        projectMatrix:
          grantedPermissions:
            - user: "admin"
              permissions:
                - "hudson.model.Hudson.Administer"
  EOC
  filename = "jenkins-config.yaml"
}

output "instance_public_ip" {
  value       = aws_instance.jenkins_instance.public_ip
  description = "The public IP address of the Jenkins server."
}

output "instance_ssh_command" {
  value       = "ssh -i \"your-key-pair.pem\" ubuntu@${aws_instance.jenkins_instance.public_ip}"
  description = "The SSH command to connect to the Jenkins server."
}
