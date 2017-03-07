provider "aws" {
  region  = "eu-west-2"
  profile = "admin"

  assume_role {
    role_arn     = "arn:aws:iam::536099501702:role/admin"
  }
}
