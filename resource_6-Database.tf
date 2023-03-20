resource "aws_db_instance" "webserver-db" {
  instance_class              = "db.t2.micro"
  allocated_storage           = 20
  vpc_security_group_ids      = [aws_security_group.db_sec-grp.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
  identifier                  = "arrow"
  db_name                     = "arrow_phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  username                    = "admin"
  password                    = "arrow123456"
  publicly_accessible         = true
  monitoring_interval         = 0
  port                        = 3306
  multi_az                    = false
  skip_final_snapshot         = true

}












