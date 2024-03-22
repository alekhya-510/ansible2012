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
    Name= " instance1"
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
    Name= " instance2"
  }
}
resource "aws_eip" "eip2"{
   domain =  "vpc"
    instance = aws_instance.instance2.id
  }
resource "aws_instance" "instance3" {
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-sb.id
  vpc_security_group_ids = [aws_security_group.instance-sg.id]
  key_name = "hanvi"
  tags= {
    Name= " instance3"
  }
}
resource "aws_eip" "eip3"{
    domain = "vpc"
    instance = aws_instance.instance3.id
  }

