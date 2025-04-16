resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id, 
    aws_subnet.public_subnet_2.id, 
    aws_subnet.public_subnet_3.id
  ]

  enable_deletion_protection = false

  tags = { Name = "Web-ALB" }
}

# Target Groups with Health Checks
resource "aws_lb_target_group" "tg_home" {
  name     = "tg-home"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_images" {
  name     = "tg-images"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_register" {
  name     = "tg-register"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

# Attach EC2 instances to Target Groups
resource "aws_lb_target_group_attachment" "home" {
  target_group_arn = aws_lb_target_group.tg_home.arn
  target_id        = aws_instance.web_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "images" {
  target_group_arn = aws_lb_target_group.tg_images.arn
  target_id        = aws_instance.web_2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "register" {
  target_group_arn = aws_lb_target_group.tg_register.arn
  target_id        = aws_instance.web_3.id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Path"
      status_code  = "404"
    }
  }
}

# Listener Rules for Path-Based Routing
resource "aws_lb_listener_rule" "home_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
  }
}

resource "aws_lb_listener_rule" "images_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/images*"]  # Correct format for subpath routing
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_images.arn
  }
}

resource "aws_lb_listener_rule" "register_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 30

  condition {
    path_pattern {
      values = ["/register*"]  # Correct format for subpath routing
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_register.arn
  }
}
