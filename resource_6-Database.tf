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
  monitoring_interval         = 0
  multi_az                    = false
  port                        = 3306
  publicly_accessible         = true
  skip_final_snapshot         = true

}


resource "github_repository_file" "webserver-db_endpoint" {
  content             = aws_db_instance.webserver-db.address
  file                = "dbserver.endpoint"
  repository          = "Project-202-Phonebook-Application-Terraform"
  overwrite_on_create = true
  branch              = "main"
  depends_on          = [aws_db_instance.webserver-db]
}











