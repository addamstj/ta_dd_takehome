# TA - Tech Assignment

# Quick Start

Clone the git repository to your local working direction 

`git clone XXX`

Next, run `terraform init` this will pull down the necessary modules and initialise the project

Next, run `terraform apply` and make sure you're happy with what is about to be created. If you're happy to go ahead, enter `yes`

To destroy what you have created, run `terraform destroy` and if you want to proceed, enter `yes`

# About the Project

## Summary
This project is designed to secure your account, it will do the following:

 - Remove the default VPCs for all regions
 - Enable CloudTrail to capture all management events
 - CloudWatch to monitor the logs and send alerts
 - S3 Bucket to store the log files
 - And all this encrypted with KMS

The alerts generated by CloudWatch will notify you of the following:

 - Usage of the "root" account
 - Management Console sign-in without MFA
 - Unauthorised API Calls

## About the Files
The files have been split out based on the AWS service they represent to make it easy for you to edit as required. 

The services used are:

 - CloudTrail
 - CloudWatch
 - KMS
 - IAM
 - S3
 - VPC
 - SNS

## What you'll need
You will need an access key and private key in order to use terraform. 

Your system administrator will be able to provide these to you. If not, you can create a user in IAM with programmatic access. 

Once you have your keys, you can set them as environment variables and Terraform will pick up the values.

To set the values: 

### Mac/Linux
```
$ export AWS_ACCESS_KEY_ID="your_aws_access_key"
$ export AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
```

### Windows

```
$ setx AWS_ACCESS_KEY_ID="your_aws_access_key"
$ setx AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
```
## Considerations
The default region has been set to `eu-west-2` or London. This can be edited in `main.tf`.

In `sns.tf` an input variable has been set to prompt you when you run `terraform plan` or `terraform apply` to enter an email address for your alerts to be sent to. 

You can change this by removing the variable block and statically entering in the email address and this will prevent you from being prompted each time you run `terraform plan` or `terraform apply`.

Once you have created the resources it is **critical** that once you receive a "Subscription" notification, to follow the link. Without doing this, it will no be possible to receive any alerts

In `s3.tf` the option `force_destroy  =  true` means the buckets will be deleted and all the contents removed when `terraform destroy` is run. Remove this line or set it to `false` if you want to preserve the s3 buckets after deletion. 

Please note, by enabling this setting to false, you may receive an error when you delete the resources as Terraform will be unable to delete an s3 bucket that has files inside. 

You can manually delete the contents of the bucket via the AWS Management Console