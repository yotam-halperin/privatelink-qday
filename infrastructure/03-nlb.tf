############
# NLB
############

resource "aws_lb" "this" {
  name               = "yotam-privatelink-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = values(aws_subnet.db_subnets)[*].id
  enable_deletion_protection = false
  security_groups = [aws_security_group.nlb_sg.id]
}

resource "aws_security_group" "nlb_sg" {
  name        = "yotam-privatelink-nlb-sg"
  description = "privatelink-demo"
  vpc_id      = aws_vpc.db_vpc.id

  ingress {
    from_port        = 5432
    to_port          = 5432
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

resource "aws_lb_target_group" "ip_tg" {
  name        = "yotam-privatelink-tg"
  port        = 5432
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.db_vpc.id
}

# resource "aws_lb_target_group_attachment" "rds_ip" {
#   target_group_arn = aws_lb_target_group.ip_tg.arn
#   target_id         = 
#   port              = 5432
# }

resource "aws_lb_listener" "privatelink" {
  load_balancer_arn = aws_lb.this.arn
  port              = "5432"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_tg.arn
  }
}