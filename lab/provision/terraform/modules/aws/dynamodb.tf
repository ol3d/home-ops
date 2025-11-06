resource "aws_dynamodb_table" "tfstate-dynamodb-aws_dynamodb_table" {
  name           = "home-ops.tfstate.lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
