terraform{
    backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "aalimsee-ce9-M2.11-tf-vpc-peering.tfstate" 
    # Replace the value of key to <your>.tfstate, eg. terraform-ex-ec2-<NAME>.tfstate
    region = "us-east-1"
  }
}