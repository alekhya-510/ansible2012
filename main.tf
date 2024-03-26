provider "aws" {
  region="us-east-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public-sb" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags={
    Name= "my-public-subnet"
  }
}
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags={
    Name= "my-igw"
  }
}
resource "aws_route_table" "rtb1" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
tags={
    Name= "public-rtb1"
  }
}
resource "aws_route_table_association" "public-rtb" {
  subnet_id = aws_subnet.public-sb.id
  route_table_id= aws_route_table.rtb1.id
}
resource "aws_security_group" "instance-sg" {
  name = "instace-sg"
  description = "allow traffic from port 22,80,8080"
  vpc_id = aws_vpc.myvpc.id
  ingress  {
    from_port = 22
    to_port= 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port= 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port= 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress  {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
  tags= {
    Name = "instance-sg"
  }
}
resource "aws_instance" "instance1" {
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-sb.id
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  key_name = "hanvi"
  tags= {
    Name= " machine 1"
  }
}
resource "aws_eip" "eip1"{
    domain = "vpc"
    instance = aws_instance.instance1.id
  }
resource "aws_instance" "instance2" {
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-sb.id
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  key_name = "hanvi"
  tags= {
    Name= " machine 2"
  }
  user_data = << EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install fontconfig openjdk-17-jre -y
              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install jenkins -y
              EOF
  }
resource "aws_instance" "instance3" {
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-sb.id
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  key_name = "hanvi"
  tags= {
    Name= " machine 3"
  }
   user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install fontconfig openjdk-17-jre
              sudo apt-get install docker.io -y
              EOF
}
