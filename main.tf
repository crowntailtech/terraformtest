provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "api_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"

  tags = {
    Name = "api-server"
  }
}

output "public_ip" {
  value = aws_instance.api_server.public_ip
}
