#resource "aws_instance" "test" {
#  ami = data.aws_ami.ami.id
#  instance_type = var.instance_type
#  subnet_id = var.subnet_id
#}
# Create Security Group
resource "aws_security_group" "sg" {
  name        = "${var.name}-${var.env}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.bastion_cidr]
  }
  ingress {
    description      = "APP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.allow_app_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.name}-${var.env}-sg"
  }
}

resource "aws_launch_template" "template" {
  name_prefix   = "${var.name}-${var.env}-lt"
  image_id      = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
}

# Create Auto-scaling group
resource "aws_autoscaling_group" "asg" {
  name               = "${var.name}-${var.env}-asg"
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}