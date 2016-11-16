# Terraform your own cyber-dojo on AWS


## Step 1 - Get your aws keys

Download your private key and put it in a folder ssh/mykey.pem

## Step - create a `terraform.tfvars` file

The contents of the file should look like this:

    aws_access_key = ""
    aws_secret_key = ""
    aws_key_path = "ssh/mykey.pem"
    aws_key_name = "cyberdojo-key"

## Step - run the terraform

    terraform plan
    terraform apply

## Step - destroy your server

    terraform destroy
