terraform {
  backend "s3" {
    bucket = "terraform-backend-shared-state"
    key = "openweatherapiforecast.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}