data "aws_vpc" "selected" {
  default = true
}

data "aws_subnets" "pb-subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

    filter {
    name = "tag:Name"
    values = ["default*"]
  }
}

// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
// https://docs.aws.amazon.com/linux/al2023/ug/ec2.html
// https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
data "aws_ami" "amazon-linux-2023" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}


data "template_file" "phonebook" {  // https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
  template = file("userdata.sh")
  vars = {
    userdata-git-token = var.git-token   // TOKEN=${userdata-git-token} --> userdata.sh
    userdata-git-name  = var.git-name    // USER=${userdata-git-name}   --> userdata.sh
  }
}

// https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file#rendered
// https://developer.hashicorp.com/terraform/language/functions/base64encode
resource "aws_launch_template" "asg-lt" {
  name = "phonebook-lt"
  image_id               = data.aws_ami.amazon-linux-2023.id
  instance_type          = "t2.micro"
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.server-sg.id]
  user_data              = base64encode(data.template_file.phonebook.rendered)
// https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on
// phonebook-app.py --line12-->> db_endpoint = open("/home/ec2-user/phonebook/dbserver.endpoint", 'r', encoding='UTF-8')
// endpoint of dbserver -->> github_repository_file.dbendpoint (dbserver.endpoint) --->> home/ec2-user
  depends_on             = [github_repository_file.dbendpoint]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web Server of Phonebook App"
    }
  }
}

resource "aws_alb_target_group" "app-lb-tg" {
  name        = "phonebook-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3

  }
}

resource "aws_alb" "app-lb" {
  name               = "phonebook-lb-tf"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = data.aws_subnets.pb-subnets.ids
}

resource "aws_alb_listener" "app-listener" {
  load_balancer_arn = aws_alb.app-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-lb-tg.arn
  }
}

resource "aws_autoscaling_group" "app-asg" {
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  name                      = "phonebook-asg"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.app-lb-tg.arn]
  vpc_zone_identifier       = aws_alb.app-lb.subnets
  launch_template {
    id      = aws_launch_template.asg-lt.id
    version = aws_launch_template.asg-lt.latest_version
  }
}

resource "aws_db_instance" "db-server" {
  instance_class              = "db.t2.micro"
  allocated_storage           = 20
  vpc_security_group_ids      = [aws_security_group.db-sg.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
  identifier                  = "phonebook-app-db"
  db_name                     = "phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  username                    = "admin"
  password                    = "arrow_123"
  monitoring_interval         = 0
  multi_az                    = false
  port                        = 3306
  publicly_accessible         = false
  skip_final_snapshot         = true

}

// https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file
resource "github_repository_file" "dbendpoint" {
  content             = aws_db_instance.db-server.address   // it will return endpoint of dbserver
  file                = "dbserver.endpoint"  
  repository          = "phonebook"
  overwrite_on_create = true
  branch              = "main"
}

data "aws_route53_zone" "selected" {
  name = var.hosted-zone
}

resource "aws_route53_record" "phonebook" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "phonebook.${var.hosted-zone}"
  type    = "A"

  alias {
    name                   = aws_alb.app-lb.dns_name
    zone_id                = aws_alb.app-lb.zone_id
    evaluate_target_health = true
  }
}