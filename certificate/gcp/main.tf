resource "google_compute_managed_ssl_certificate" "certificate" {
  name = "certificate-${var.project_id}-${var.project_env}"

  managed {
    domains = var.dns_name
  }
}
