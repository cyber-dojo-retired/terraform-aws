# Terraform your own cyber-dojo on AWS

## Step 0 - Create the packer image

    export AWS_ACCESS_KEY=<your_key>
    export AWS_SECRET_KEY=<your_key>
    packer build -machine-readable packer.json

## Step 1 - Get your aws keys

Download your private key and put it in a folder ssh/mykey.pem

## Step - create a `terraform.tfvars` file

The contents of the file should look like this:

    aws_key_path = "ssh/mykey.pem"
    aws_key_name = "cyberdojo-key"

And the  AWS_ACCESS_KEY and AWS_SECRET_KEY should be availble in the environment.

## Step - run the terraform

    terraform plan
    terraform apply

## Step - destroy your server

    terraform destroy
