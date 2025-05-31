#Certificate
resource "aws_acm_certificate" "certificate" {
  domain_name       = var.dns_name
  validation_method = var.validation_method

  depends_on = [aws_route53_zone.route53_zone]
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record_validation : record.fqdn]
}

resource "aws_route53_zone" "route53_zone" {
  count = var.validation_method == "DNS" ? 1 : 0

  name = var.dns_name
}

#DNS Validation
resource "aws_route53_record" "route53_record_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.route53_zone[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}
