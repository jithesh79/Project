
# Interview Lab - Terraform + ECS + RDS + EC2 + ALB (path-based routing)

**Domain:** interview-lab.duckdns.org
**AWS Region:** ap-south-1
**VPC:** create-new
**S3 static website:** enabled
**Terraform remote backend:** enabled (bootstrap step provided)
**Instance type:** t2.micro

## What is included
- Terraform modules for VPC, ALB, ECS skeleton, RDS, EC2
- Microservice (Node.js) + Dockerfile
- GitHub Actions workflow to build and push microservice to ECR
- EC2 user-data script to install Docker, run container, install NGINX and configure routes
- Bootstrap terraform to create S3 bucket + DynamoDB table for remote state locking
- Documentation PDF (this package) and the original task prompt

## Quick start (recommended)
1. Bootstrap backend (creates S3 bucket and DynamoDB table used for terraform remote state):
   ```
   cd terraform/bootstrap-backend
   terraform init
   terraform apply -var='backend_bucket_name=YOUR_BACKEND_BUCKET_NAME' -var='backend_dynamodb_table=YOUR_LOCK_TABLE' -var='region=ap-south-1'
   ```

2. Initialize main terraform with backend config (replace BUCKET and TABLE names):
   ```
   cd ../../terraform
   terraform init -backend-config="bucket=YOUR_BACKEND_BUCKET_NAME" -backend-config="dynamodb_table=YOUR_LOCK_TABLE" -backend-config="region=ap-south-1"
   terraform apply -var='project_name=interview-lab' -var='vpc_create=true' -auto-approve
   ```

3. After apply completes, note the ALB DNS in the outputs. Configure your DuckDNS to point to the ALB (or configure an A/ALIAS record to the ALB DNS if supported).

4. Use the following test paths:
   - https://interview-lab.duckdns.org/wordpress
   - https://interview-lab.duckdns.org/microservice
   - https://interview-lab.duckdns.org/ec2-instance1
   - https://interview-lab.duckdns.org/ec2-docker1
   - https://interview-lab.duckdns.org/ec2-instance2
   - https://interview-lab.duckdns.org/ec2-docker2
   - https://interview-lab.duckdns.org/static (S3 static site)

## Cleanup
To destroy resources:
```
cd terraform
terraform destroy -auto-approve
```

Then destroy the backend bootstrap resources:
```
cd terraform/bootstrap-backend
terraform destroy -var='backend_bucket_name=YOUR_BACKEND_BUCKET_NAME' -var='backend_dynamodb_table=YOUR_LOCK_TABLE' -auto-approve
```
