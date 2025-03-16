resource "aws_s3tables_table" "example" {
  name             = var.table_name
  namespace        = aws_s3tables_namespace.example.namespace
  table_bucket_arn = aws_s3tables_namespace.example.table_bucket_arn
  format           = "ICEBERG"
}

resource "aws_s3tables_namespace" "example" {
  namespace        = var.namespace
  table_bucket_arn = aws_s3tables_table_bucket.example.arn
}

resource "aws_s3tables_table_bucket" "example" {
  name = var.table_bucket_name
}