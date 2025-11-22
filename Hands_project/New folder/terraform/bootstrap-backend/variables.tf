
variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "backend_bucket_name" {
  type = string
}

variable "backend_dynamodb_table" {
  type = string
}
