##In this project i am going to create AWS resources such as VPC, Subnet, Route Table, Internet gateway, security group, Ec2 instance, s3 bucket etc. using Terraform.

-Inorder to perform this project you have to create a IAM role, Accesskeys and secret access key for connecting to aws account via aws cliv2.

- install aws cli on your system then verify
```bash
aws --version
```
you should see output like 
`aws-cli/2.15.20 Python/3.11.5 Linux/x86_64 source`

- Add your IAM Access keys and Secret Keys
`aws configure`

- create a file named provider.tf write provider configuration
```hcl
  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

