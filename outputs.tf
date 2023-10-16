output "vpc_id" {
  value = aws_vpc.mumbai-vpc.id
}

output "vpc_fe_subnet" {
  value = aws_subnet.private[0]
}

output "vpc_be_subnet" {
  value = aws_subnet.private[1]
}

output "vpc_ig" {
  value = aws_internet_gateway.mumbai-igw.id
}

output "vpc_rt" {
  value = aws_route_table.mumbai-public-route.id
}

output "vpc_nacl_fe" {
  value = aws_network_acl.mumbai-nacl[0].id
}

output "vpc_nacl_be" {
  value = aws_network_acl.mumbai-nacl[1].id
}

output "vpc_fe_sg" {
  value = aws_security_group.mumbai-securitygroup[0].id
}

output "vpc_be_sg" {
  value = aws_security_group.mumbai-securitygroup[1].id
}