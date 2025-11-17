# Data source for latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_region" "current" {}

# Security Group for Jenkins
resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Security group for Jenkins server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins UI"
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name    = "${var.project_name}-jenkins-sg"
      Type    = "Security-Group"
      Service = "Jenkins"
    }
  )
}

# EC2 Instance for Jenkins
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins.id]
  key_name               = var.key_name
  monitoring             = var.enable_detailed_monitoring

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-jenkins-volume"
        Type = "EBS"
      }
    )
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git wget curl vim docker
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user
              curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
              curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
              install minikube-linux-amd64 /usr/local/bin/minikube
              dd if=/dev/zero of=/swapfile bs=1M count=2048
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
              rpm -U ./amazon-cloudwatch-agent.rpm
              EOF

  tags = merge(
    var.tags,
    {
      Name      = "${var.project_name}-jenkins-server"
      Type      = "EC2"
      Service   = "Jenkins"
      Role      = "CI-CD-Server"
      OS        = "Amazon-Linux-2023"
      Ansible   = "managed"
      AutoStart = "No"
    }
  )
}

# Elastic IP for Jenkins
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-jenkins-eip"
      Type = "EIP"
    }
  )

  depends_on = [aws_instance.jenkins]
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-jenkins-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = []

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }

  tags = merge(var.tags, { Name = "${var.project_name}-cpu-alarm", Type = "CloudWatch-Alarm", Severity = "Warning" })
}

resource "aws_cloudwatch_metric_alarm" "disk_high" {
  alarm_name          = "${var.project_name}-jenkins-disk-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "This metric monitors disk usage"
  alarm_actions       = []
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.jenkins.id
    path       = "/"
    fstype     = "xfs"
    device     = "nvme0n1p1"
  }

  tags = merge(var.tags, { Name = "${var.project_name}-disk-alarm", Type = "CloudWatch-Alarm", Severity = "Warning" })
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.project_name}-jenkins-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = 85
  alarm_description   = "This metric monitors memory usage"
  alarm_actions       = []
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.jenkins.id
  }

  tags = merge(var.tags, { Name = "${var.project_name}-memory-alarm", Type = "CloudWatch-Alarm", Severity = "Warning" })
}

# CloudWatch Dashboard with 1–2 items per metric array
resource "aws_cloudwatch_dashboard" "jenkins" {
  dashboard_name = "${var.project_name}-jenkins-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization"]
          ]
          period = 300
          stat   = "Average"
          region = data.aws_region.current.name
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn"]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "Network In"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkOut"]
          ]
          period = 300
          stat   = "Sum"
          region = data.aws_region.current.name
          title  = "Network Out"
        }
      }
    ]
  })
}

