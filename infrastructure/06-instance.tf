resource "aws_instance" "this" {
    ami = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.this.id
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    user_data = file("./init.sh")
    tags = {
      "Name" = "yotam-privatelink-instance"
      "Expiration" = "20-04-24"
      "Email" = "yotam.halperin@develeap.com"
      "Objective" = "privatelink"
    }
}

resource "aws_security_group" "instance_sg" {
  name        = "yotam-privatelink-instance-sg"
  description = "privatelink-demo"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}