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
```
#### 2. MongoDB Atlas Setup

Created free-tier cluster.

Whitelisted EC2 public IP.

Created a database user.

Retrieved connection string for use in backend .env.



#### 2. Backend Setup (Ansible)

Cloned the blog app repository.

Created .env file using Ansible template.

Installed dependencies and started the backend using PM2.


Command used:
```bash
ansible-playbook -i inventory backend-playbook.yml
```
#### 2. 4. Frontend Setup (Ansible)

Created .env file for frontend.

Installed frontend dependencies using pnpm.

Built the frontend and deployed it to the S3 bucket.


Command used:

```bash
ansible-playbook -i inventory frontend-playbook.yml

```
5. Media Upload & Test
Verified media upload to the configured S3 bucket using the application UI.


Cleanup Steps
Used terraform destroy to clean up AWS resources.

Removed sensitive .env files from EC2.

Deleted IAM user and keys.

Cleaned up MongoDB Atlas user and IP access.



