resource "aws_vpc" "vpc1" {
    cidr_block = var.cidr

    tags = {
        name = "vpc1"
    }
  
}


#subnet

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

##route table association with subnet1
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt1.id
}

##route table association with subnet2
 resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt1.id
 }

 # security grp for ec2

 resource "aws_security_group" "web-sg" {
   name = "web-sg"
   description = "Allow TLS inbound traffic"
   vpc_id = aws_vpc.vpc1.id

   ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
    Name = "web-sg"
   }

 }


 # s3 bucket

 resource "aws_s3_bucket" "example" {
  bucket = "manaskumarss3bucket7846"
 }

#access control list - public access
 resource "aws_s3_bucket_acl" "example" {
 
   bucket = aws_s3_bucket.example.id
   acl    = "public-read"
 }

 # create ec2 instance
 resource "aws_instance" "webserver1" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id = aws_subnet.sub1.id
  user_data_base64 = base64encode(file("userdata.sh"))
   
 }
