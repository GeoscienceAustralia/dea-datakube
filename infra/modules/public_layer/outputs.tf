#==============================================================
# Public / outputs.tf
#==============================================================

output "jump_ssh_sg_id" {
  value = "${aws_security_group.jump_ssh_sg.id}"
}

output "nat_ids" {
  value = "${split(",", (var.enable_nat && var.enable_gateways) ? join(",", aws_nat_gateway.nat.*.id) : join(",", list()))}"
}

output "nat_instance_ids" {
  value = "${split(",", (var.enable_nat && !var.enable_gateways) ? join(",", aws_instance.ec2_nat.*.id) : join(",", list()))}"
}
