resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.PUBLIC_SUBNETS)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PUBLIC_SUBNETS[count.index]
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC PUBLIC SUBNET ${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.PRIVATE_SUBNETS)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.PRIVATE_SUBNETS[count.index]
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC PRIVATE SUBNET ${count.index + 1}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Internet Gateway"
    }
  )
}

resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Default Route Table"
    }
  )
}

resource "aws_route_table" "public_rt_only" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Public Route"
    }
  )
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public_rt_only.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table" "private_rt" {

  count  = length(var.PRIVATE_SUBNETS)
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Private Route Tables"
    }
  )
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.PUBLIC_SUBNETS)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt_only.id
}

resource "aws_eip" "nat_eip" {

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - ElasticIP for Natgateway"
    }
  )
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.igw]

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Natgateway"
    }
  )
}

resource "aws_route" "pvtnat_route" {
  count                  = length(var.PRIVATE_SUBNETS)
  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table_association" "pvt_route_assoc" {
  count          = length(var.PRIVATE_SUBNETS)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

resource "aws_default_network_acl" "nacl_default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  #IPv4
  ingress {
    protocol   = -1 #all
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  #IPv6
  ingress {
    protocol        = -1 #all
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  #IPv4
  egress {
    protocol   = -1 #all
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  #IPv6
  egress {
    protocol        = -1 #all
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = merge(
    local.tags,
    {
      "Propose" = "Network",
      "Name"    = "${var.PROJECT}-VPC - Natgateway"
    }
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }

}