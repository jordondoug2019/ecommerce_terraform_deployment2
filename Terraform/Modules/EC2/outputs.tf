output "FrontEnd_SecurityGroup" {
  value = aws_security_group.FrontEnd_SecurityGroup.id
  
}
output "BackEnd_SecurityGroup" {
  value = aws_security_group.BackEnd_SecurityGroup.id
  
}
output "frontend_instance_ids" {
  value = aws_instance.FrontEnd[*].id  # Return a list of IDs for all instances
}

