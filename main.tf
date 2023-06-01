#resource "aws_instance" "test" {
#  ami = data.aws_ami.ami.id
#  instance_type = var.instance_type
#  subnet_id = var.subnet_id
#}
#
resource "aws_launch_template" "foobar" {
  name_prefix   = "${var.name}-${var.env}"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}