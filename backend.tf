terraform {
  backend "s3" {
    bucket = "loadbalance1-project-bucket"  # Replace with your unique S3 bucket name
    key    = "path/to/my/statefile/terraform.tfstate"  # Path inside the bucket to store the state
    region = "ap-southeast-2"  # Replace with your desired AWS region
    encrypt = true  # Enable encryption of the state file
   
  }
}
