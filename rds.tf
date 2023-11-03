resource "aws_db_instance" "hosp_info" {
  allocated_storage      = 20
  max_allocated_storage  = 1000
  identifier             = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info"
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "hwaseon!00"
  port                   = 3306
  skip_final_snapshot    = true
  storage_type           = "gp2"
  vpc_security_group_ids = [aws_security_group.hosp_info_rdb.id]
  db_subnet_group_name   = aws_db_subnet_group.hosp_info.name
  availability_zone      = data.aws_availability_zones.available.names[0]
  network_type           = "IPV4"
  license_model          = "general-public-license"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info-rdb"
    }
  )
}

resource "aws_db_subnet_group" "hosp_info" {
  name       = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info-rdb-sbn-group"
  subnet_ids = concat(aws_subnet.private.*.id, aws_subnet.public.*.id)
  tags = merge(
    local.common_tags,
    {
      Name = "${var.name_prefix}-${var.service_name}-${var.env}-hosp-info-rdb-sbn-group"
    }
  )
}
