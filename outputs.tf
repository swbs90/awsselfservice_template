output "nomad_server_ip" {
  value = [
    for k, v in aws_instance.my_instance :
    "${v.public_ip}"
  ]
}
