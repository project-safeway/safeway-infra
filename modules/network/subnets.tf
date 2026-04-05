resource "aws_subnet" "public_a" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "private_frontend" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-frontend"
  }
}

resource "aws_subnet" "private_frontend_b" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-frontend-b"
  }
}

resource "aws_subnet" "private_backend" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-backend"
  }
}

resource "aws_subnet" "private_backend_b" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-backend-b"
  }
}

resource "aws_subnet" "private_database" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-database"
  }
}

resource "aws_subnet" "private_database_b" {
  vpc_id = var.vpc_id

  cidr_block        = "10.0.13.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-database-b"
  }
}