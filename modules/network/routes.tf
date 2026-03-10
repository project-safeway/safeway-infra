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

# Private route table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "safeway-private-rt"
  }
}

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a.id
}

resource "aws_route_table_association" "private_frontend_assoc" {
  subnet_id      = aws_subnet.private_frontend.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_backend_assoc" {
  subnet_id      = aws_subnet.private_backend.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_database_assoc" {
  subnet_id      = aws_subnet.private_database.id
  route_table_id = aws_route_table.private.id
}