# Step 10 - Add output variables
output "public_ip" {
  value = aws_instance.clo835-host-EC2.public_ip
}

output "clo835_ecr" {
  value = aws_ecr_repository.clo835-ecr.name
}