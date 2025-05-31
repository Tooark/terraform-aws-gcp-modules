# Saída de dados do recurso do Bucket Storage
output "resource_bucket_storage" {
  value = {
    _id           = google_storage_bucket.bucket-storage.id
    name          = google_storage_bucket.bucket-storage.name
    url           = google_storage_bucket.bucket-storage.url
    location      = google_storage_bucket.bucket-storage.location
    force_destroy = google_storage_bucket.bucket-storage.force_destroy
    storage_class = google_storage_bucket.bucket-storage.storage_class
    labels        = google_storage_bucket.bucket-storage.terraform_labels
    cors          = google_storage_bucket.bucket-storage.cors
    _project      = google_storage_bucket.bucket-storage.project
    _link         = google_storage_bucket.bucket-storage.self_link
  }
  description = "Dados do recurso do Bucket Storage"
}

# Saída de dados do recurso de Permissão do AllUsers do Bucket Storage
output "resource_bucket_storage_iam" {
  value = [for permission in google_storage_bucket_iam_binding.bucket-storage-iam : {
    _id    = permission.id
    bucket = permission.bucket
    role   = permission.role
  }]
  description = "Dados do recurso de Permissão do AllUsers do Bucket Storage"
}

# Saída de dados do recurso para criação de um Service Account para o Storage
output "resource_storage_account" {
  value = [for account in google_service_account.storage-account : {
    _id         = account.id
    name        = account.display_name
    email       = account.email
    member      = account.member
    description = account.description
    disabled    = account.disabled
    _project    = account.project
  }]
  description = "Dados do recurso para criação de um Service Account para o Storage"
}

# Saída de dados do recurso de Permissão para a Service Account Storage
output "resource_storage_account_iam" {
  value = [for account in google_project_iam_member.storage-account-iam : {
    _id      = account.id
    bucket   = account.project
    member   = account.member
    role     = account.role
    _project = account.project
  }]
  description = "Dados do recurso de Permissão para a Service Account Storage"
}

# Saída de dados do recurso para criar Private e Public Key para a Service Account Storage
output "resource_storage_account_key" {
  value = [for key in google_service_account_key.storage-account-key : {
    _id                = key.id
    service_account_id = key.service_account_id
    valid_after        = key.valid_after
    valid_before       = key.valid_before
  }]
  description = "Dados do recurso para criar Private e Public Key para a Service Account Storage"
}

# ID do Storage Bucket
output "storage_id" {
  value       = google_storage_bucket.bucket-storage.id
  description = "ID do Storage Bucket"
}

# Nome do Storage Bucket
output "storage_name" {
  value       = google_storage_bucket.bucket-storage.name
  description = "Nome do Storage Bucket"
}

# URL do Storage Bucket
output "storage_url" {
  value       = google_storage_bucket.bucket-storage.url
  description = "URL do Storage Bucket"
}

# Link do Storage Bucket
output "storage_link" {
  value       = google_storage_bucket.bucket-storage.self_link
  description = "Link do Storage Bucket"
}

# Role do Storage Bucket
output "storage_role" {
  value = [for bind in google_storage_bucket_iam_binding.bucket-storage-iam : {
    role = bind.role
  }]
  description = "Role do Storage Bucket"
}

# ID da Service Account
output "storage_account_id" {
  value = [for account in google_service_account.storage-account : {
    _id = account.id
  }]
  description = "ID da Service Account"
}

# Nome da Service Account
output "storage_account_name" {
  value = [for account in google_service_account.storage-account : {
    name = account.display_name
  }]
  description = "Nome da Service Account"
}

# Email da Service Account
output "storage_account_email" {
  value = [for account in google_service_account.storage-account : {
    email = account.email
  }]
  description = "Email da Service Account"
}

# Membro da Service Account
output "storage_account_member" {
  value = [for account in google_service_account.storage-account : {
    member = account.member
  }]
  description = "Membro da Service Account"
}

# Role da Service Account
output "storage_account_role" {
  value = [for account in google_project_iam_member.storage-account-iam : {
    role = account.role
  }]
  description = "Role da Service Account"
}
