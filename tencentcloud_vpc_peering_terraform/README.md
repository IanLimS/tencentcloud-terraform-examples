# TencentCloud VPC VPN Terraform Project

## Project Overview
This project provides Terraform code for configuring VPC and VPN Gateway on Tencent Cloud. Key features include:
- VPC creation and configuration
- VPN Gateway setup
- VPC Peering connection
- Security Group rule management

## Environment Setup
### Prerequisites
1. **Install Terraform**
   - Refer to the [official documentation](https://developer.hashicorp.com/terraform/downloads) to install Terraform.
   ```bash
   brew install terraform
   ```
2. **Set up Tencent Cloud Account**
   - A Tencent Cloud account is required, and you need to generate API keys.
   - Set environment variables in `~/.bashrc` or `~/.zshrc`:
   ```bash
   export TENCENTCLOUD_SECRET_ID="your-secret-id"
   export TENCENTCLOUD_SECRET_KEY="your-secret-key"
   export TENCENTCLOUD_REGION="ap-seoul"
   ```

## Deployment Steps
1. **Initialize Terraform**
   ```bash
   terraform init
   ```
2. **Review Execution Plan**
   ```bash
   terraform plan
   ```
3. **Deploy Infrastructure**
   ```bash
   terraform apply
   ```
4. **Destroy Infrastructure (if needed)**
   ```bash
   terraform destroy
   ```

## References
- [Tencent Cloud VPC Documentation](https://www.tencentcloud.com/document/product/215)
- [Terraform TencentCloud Provider Documentation](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs)