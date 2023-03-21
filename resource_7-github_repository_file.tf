resource "github_repository_file" "webserver-db_endpoint" {
  content             = aws_db_instance.webserver-db.address
  file                = "dbserver.endpoint"
  repository          = "Project-202-Phonebook-Application-Terraform"
  overwrite_on_create = true
  branch              = "main"
}











