output "certificate" {
  value = {
    id                = aws_acm_certificate.certificate.arn
    name              = aws_acm_certificate.certificate.domain_name
    validation_method = aws_acm_certificate.certificate.validation_method
    record_validation = aws_acm_certificate_validation.certificate_validation.validation_record_fqdns
  }
  description = "Dados do certificado"
}

output "ceritifcate_name" {
  value       = aws_acm_certificate.certificate.domain_name
  description = "Nome do dns no certificado"
}

output "certificate_arn" {
  value       = aws_acm_certificate.certificate.arn
  description = "ID do certificado"
}
