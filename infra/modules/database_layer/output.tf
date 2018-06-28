output "db_username" {
  value = "${var.db_username}"
}

output "db_password" {
  value = "${random_string.password.result}"
}

output "instance_sg" {
  value = "${aws_security_group.instance.id}"
}
