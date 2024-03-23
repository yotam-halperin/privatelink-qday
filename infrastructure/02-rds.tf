############
# RDS
############

resource "aws_db_instance" "this" {
  identifier = "yotam-privatelink-rds"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "postgres"
  storage_type = "gp2"
  storage_encrypted    = true
  skip_final_snapshot  = true
  copy_tags_to_snapshot = true
  allocated_storage = 20
  max_allocated_storage = 30
  deletion_protection = false
  multi_az = false
  apply_immediately = true
  publicly_accessible = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.this.name
}

resource "aws_security_group" "rds_sg" {
  name        = "yotam-privatelink-rds-sg"
  description = "privatelink-demo"
  vpc_id      = aws_vpc.db_vpc.id

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "yotam-privatelink-subnetgroup"
  description = "privatelink"
  subnet_ids = values(aws_subnet.db_subnets)[*].id
}