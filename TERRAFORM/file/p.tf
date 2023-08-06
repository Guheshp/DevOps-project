provider "aws" {
    region = "ap-south-1"
    access_key = "AKIATVX5SBZQTTXB6RZX"
    secret_key = "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"
  
}

resource "aws_instance" "backend" {
    ami = "ami-0b9ecf71fe947bbdd"
    instance_type = "t2.micro"
    tags = {
       name = "instance ${count.index}" 
    }
    count = 10
    
     
}