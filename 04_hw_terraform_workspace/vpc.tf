# 1. Create a VPC
resource "aws_vpc" "devops_main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "devops_main"
  }
}

# 2. Define your Subnets (2 AZs)
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.devops_main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.devops_main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Create Elastic IPs
resource "aws_eip" "nat_eip_a" {
  vpc = true

  tags = {
    Name = "nat-eip-a"
  }
}

resource "aws_eip" "nat_eip_b" {
  vpc = true

  tags = {
    Name = "nat-eip-b"
  }
}

# Create NAT Gateways
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.subnet_a.id

  tags = {
    Name = "nat-gateway-a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.subnet_b.id

  tags = {
    Name = "nat-gateway-b"
  }
}

# Update Route Tables
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.devops_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "private-route-table-a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.devops_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_b.id
  }

  tags = {
    Name = "private-route-table-b"
  }
}

resource "aws_route_table_association" "private_subnet_a_assoc" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_b_assoc" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}



# # Create Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.devops_main.id
# }

# # Create Route Table
# resource "aws_route_table" "route_table" {
#   vpc_id = aws_vpc.devops_main.id

#   route {
#     cidr_block = var.cidr_block
#     gateway_id = aws_internet_gateway.igw.id
#   }
# }

# # Associate Subnets with Route Table
# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.subnet_a.id
#   route_table_id = aws_route_table.route_table.id
# }

# resource "aws_route_table_association" "b" {
#   subnet_id      = aws_subnet.subnet_b.id
#   route_table_id = aws_route_table.route_table.id
# }