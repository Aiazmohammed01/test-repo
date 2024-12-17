resource "aws_route53_record" "devops_record" {
  zone_id = data.aws_route53_zone.example_com.id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ubuntu_server.public_ip]
}

resource "aws_route53_record" "www_devops_record" {
  zone_id = data.aws_route53_zone.example_com.id
  name    = "www.devops"
  type    = "CNAME"
  ttl     = 300
  records = ["www.devops.example1.com"]
}
