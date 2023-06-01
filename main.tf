resource "aws_instance" "test" {
  count=length(subnet_id)
  ami = "ami-08ee87f57b38db5af"
  instance_type = var.instance_type
  subnet_id = var.subnet_id
}

