# MERN Stack Blog App Deployment - Week 11 Assignment

 Infrastructure Bootcamp | Clarusway

---

## Project Overview

In this project, I deployed a MERN Stack Blog Application on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

###  Architecture Overview

- **Backend:** Node.js Express API running on EC2 (Ubuntu 22.04)
- **Frontend:** React app hosted on AWS S3 (Static Website Hosting)
- **Database:** MongoDB Atlas (Free-tier)
- **Media Uploads:** Separate S3 Bucket with IAM policy for secure programmatic uploads

---

## Tools Used

- AWS EC2, S3, IAM
- MongoDB Atlas
- Terraform
- Ansible
- PM2 (Process Manager)
- AWS CLI

---

## Deployment Steps

### 1. Infrastructure Setup (Terraform)

- Created Security Group for SSH (22), HTTP (80), and App Port (5000).
- Launched EC2 (t3.micro) instance in `eu-north-1`.
- Created IAM User and attached policy for S3 media bucket access.
- Created S3 buckets for frontend and media uploads.

#### Commands used:
```bash
terraform init
terraform apply -auto-approve -var="key_pair=YOUR_KEY_PAIR" -var="media_bucket_name=YOUR_MEDIA_BUCKET"
