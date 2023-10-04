# To create ALB
  resource "aws_lb" "test" {
  internal           = false
  name               = "tokyo-alb"
  load_balancer_type = "application"
  subnets         = ["aws_subnet.tokyo-frontend-subnet[0].id","aws_subnet.tokyo-backend-subnet[0].id"]
  security_groups = ["aws_security_group.tokyo-frontend-securitygroup.id","aws_security_group.tokyo-backend-securitygroup.id"]
#  security_groups    = ["sg-0824b69e0d14714b2", "sg-0cbdb19706e68e034"]
#  subnets            = ["subnet-0f4c91884b1d68e9c", "subnet-0ee09ebb309e5dbf0"]
  enable_deletion_protection = true
  access_logs  {
    bucket = "aws_s3_bucket.lb_logs.id"
    prefix  = "tokyo-alb"
    enabled = true
  }
}