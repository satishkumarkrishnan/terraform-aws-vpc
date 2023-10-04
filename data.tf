data "template_file" "backend_cloud_init" {
  template = file("bootstrap.sh")
}
#data "aws_availability_zones" "available" {
#}
