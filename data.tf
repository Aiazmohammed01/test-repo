data "aws_route53_zone" "example_com" {
  name = "devops.example1.com"  # The domain name of your existing hosted zone
}