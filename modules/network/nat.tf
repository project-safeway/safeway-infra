resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "safeway-nat-eip"
  }
}

resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "safeway-nat-b-eip"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "safeway-nat-a"
  }

  depends_on = [var.igw_id]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "safeway-nat-b"
  }

  depends_on = [var.igw_id]
}