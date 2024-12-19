#VPC

resource "aws_vpc" "wl5vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "wl5vpc"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "wl5-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "wl5-igw"
  }
}

#Subnet Block

resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)
  vpc_id = var.vpc_id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnet" {
  count  = length(var.availability_zones)
   vpc_id = var.vpc_id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]


  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Elastic IP for both Nat Gateways
resource "aws_eip" "wl5_nat_eip" {
  count  = 2
  domain = "vpc"
  
  tags = {
    Name = "NAT Gateway EIP ${count.index + 1}"
  }
}

# Create NAT Gateways in public subnets
resource "aws_nat_gateway" "nat_gateway" {
  count = 2
  allocation_id = aws_eip.wl5_nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "NAT Gateway AZ${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.wl5-igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wl5-igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }

  tags = {
    Name = "private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count = 2
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  count = 2
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

#Application Load Balancer
resource "aws_lb" "PublicSubnet_LB" {
  name               = "PublicSubnet-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.FrontEnd_SecurityGroup_id]
  subnets            = var.public_subnet

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "PublicSubnet_TG" {
  name     = "PublicSubnet-TG"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

#resource "aws_lb_target_group_attachment" "test" {
 # target_group_arn = aws_lb_target_group.PublicSubnet_TG.arn
  #target_id        = var.ec2_instance_id
  #port             = 3000
#}

resource "aws_lb_target_group_attachment" "test" {
  count          = length(var.ec2_instance_ids)  # Adjust for the number of instances
  target_group_arn = aws_lb_target_group.PublicSubnet_TG.arn
  target_id        = var.ec2_instance_ids[count.index]  # Use count to iterate
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.PublicSubnet_LB.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.PublicSubnet_TG.arn
  }
}



resource "aws_db_instance" "postgres_db" {
  identifier           = "ecommerce-db"
  engine               = "postgres"
  engine_version       = "14.13"
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  storage_type         = "standard"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "Ecommerce Postgres DB"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.private_subnet

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.Backend_SecurityGroup_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}

resource "aws_vpc_peering_connection" "VPC_Peering" {
  peer_vpc_id   = "vpc-05aa3c03006594d4e"
  vpc_id        = var.vpc_id
  auto_accept   = true

  tags = {
    Name = "VPC Peering between Accepter and Requester"
  }
}

