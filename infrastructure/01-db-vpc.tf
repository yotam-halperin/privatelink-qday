resource "aws_vpc" "db_vpc" {
  cidr_block       = "10.70.0.0/16"

  tags = {
    Name = "yotam-db-vpc"
  }
}

data "aws_region" "current" {}

resource "aws_subnet" "db_subnets" {
  for_each = {"${data.aws_region.current.name}a":"10.70.10.0/24","${data.aws_region.current.name}b":"10.70.20.0/24"}

  vpc_id     = aws_vpc.db_vpc.id
  cidr_block = each.value
  # map_public_ip_on_launch = true
  availability_zone = each.key
  tags = {
    Name = "yotam-db-subnet-${each.key}"
  }
}

