provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "blogapp"
  public_key = file("C:/Users/pc/.ssh/blogapp-key.pub")
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow SSH, HTTP, and app port"

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

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "media" {
  bucket = var.media_bucket_name
}

resource "aws_s3_bucket" "frontend" {
  bucket = var.frontend_bucket_name

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_iam_user" "s3_user" {
  name = "s3-upload-user"
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "s3-upload-policy"
  user = aws_iam_user.s3_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${var.media_bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_instance" "backend" {
  ami                    = "ami-0c1ac8a41498c1a9c" # Ubuntu 22.04 eu-north-1
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = {
    Name = "mern-backend"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python3-pip"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:\\Users\\pc\\.ssh\\blogapp-key")
      host        = self.public_ip
    }
  }
}

output "ec2_public_ip" {
  value = aws_instance.backend.public_ip
}

output "s3_user_access_key" {
  value     = aws_iam_access_key.s3_user_key.id
  sensitive = true
}

output "s3_user_secret_key" {
  value     = aws_iam_access_key.s3_user_key.secret
  sensitive = true
}
