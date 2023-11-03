resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for r in aws_route_table.private_route : r.id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpce-s3"
    }
  )
}

resource "aws_vpc_endpoint" "dkr" {
  vpc_id              = aws_vpc.main.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]
  subnet_ids = [for s in aws_subnet.private : s.id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpce-dkr"
    }
  )
}

resource "aws_vpc_endpoint" "dkr_api" {
  vpc_id              = aws_vpc.main.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]
  subnet_ids = [for s in aws_subnet.private : s.id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpce-dkr_api"
    }
  )
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]
  subnet_ids = [for s in aws_subnet.private : s.id]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-vpce-logs"
    }
  )
}
