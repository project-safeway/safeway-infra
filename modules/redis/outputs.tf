output "private_ip" {
  value = aws_instance.redis.private_ip
}

output "instance_id" {
  value = aws_instance.redis.id
}
