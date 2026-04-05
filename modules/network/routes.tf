# Public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "safeway-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Private route table (AZ A)
resource "aws_route_table" "private_a" {
  vpc_id = var.vpc_id

  tags = {
    Name = "safeway-private-rt-a"
  }
}

resource "aws_route" "private_internet_a" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route_table_association" "private_frontend_assoc" {
  subnet_id      = aws_subnet.private_frontend.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_backend_assoc" {
  subnet_id      = aws_subnet.private_backend.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_database_assoc" {
  subnet_id      = aws_subnet.private_database.id
  route_table_id = aws_route_table.private_a.id
}

# Private route table (AZ B)
resource "aws_route_table" "private_b" {
  vpc_id = var.vpc_id

  tags = {
    Name = "safeway-private-rt-b"
  }
}

resource "aws_route" "private_internet_b" {
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_b.id
}

resource "aws_route_table_association" "private_frontend_assoc_b" {
  subnet_id      = aws_subnet.private_frontend_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_backend_assoc_b" {
  subnet_id      = aws_subnet.private_backend_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "private_database_assoc_b" {
  subnet_id      = aws_subnet.private_database_b.id
  route_table_id = aws_route_table.private_b.id
}