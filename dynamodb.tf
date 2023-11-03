resource "aws_dynamodb_table" "users_table" {
  name           = "Users-${var.env}"
  hash_key       = "pk"
  range_key      = "sk"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  global_secondary_index {
    name            = "sk-pk-index"
    hash_key        = "sk"
    range_key       = "pk"
    projection_type = "ALL"
    read_capacity   = 10
    write_capacity  = 5
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "aws_dynamodb_table" "feeds_table" {
  name           = "Feeds-${var.env}"
  hash_key       = "patientID"
  range_key      = "createDate"
  read_capacity  = 10
  write_capacity = 10

  attribute {
    name = "patientID"
    type = "S"
  }

  attribute {
    name = "createDate"
    type = "S"
  }

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
