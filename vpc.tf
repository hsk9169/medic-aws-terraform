resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpc"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-public_sbn"
    }
  )
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-public_rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_route.*.id, count.index)
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-private_sbn"
    }
  )
}

resource "aws_route_table" "private_route" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.main.*.id, count.index)
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-private_rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-igw"
    }
  )
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_nat_gateway" "main" {
  count         = var.az_count
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-natgw"
    }
  )
}

resource "aws_eip" "nat" {
  count = var.az_count
  #vpc = true (deprecated)
  domain = "vpc"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-natgw_eip"
    }
  )
}

resource "aws_service_discovery_private_dns_namespace" "app" {
  name        = "${var.name_prefix}-${var.service_name}-${var.env}.hands-on.cloud.local"
  description = "${var.name_prefix}-${var.service_name}-${var.env}.hands-on.cloud.local zone"
  vpc         = aws_vpc.main.id
}
