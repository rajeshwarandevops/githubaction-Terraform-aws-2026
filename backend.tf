
terraform {
  backend "s3" {
    bucket         = "terraform-github-action-23072025"
    key            = "devopsforu/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-locks" # optional for state locking
  }

}


