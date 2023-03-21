variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "launch-template_name" {
  description = "Phonebook-Launch-Template"
  type        = string
  default     = "phonebook-app_ec2_lt"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "arrow"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "arrow_phonebook_instance"
}

variable "git-name" {
  default = "alparslanu6347"
}

variable "git-token" {
  default = "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"
}
variable "hosted-zone" {
  default = "devopsalparslanugurer.com"
}

