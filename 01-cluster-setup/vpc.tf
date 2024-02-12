module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "~>5.0"
  name           = "training-vpc"
  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/16"]
  azs            = ["eu-west-1a"]
}


