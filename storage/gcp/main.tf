# Cria as variáveis do locals
locals {
  workspace_map = {
    dev             = "dev"
    development     = "dev"
    desenvolvimento = "dev"
    hml             = "hml"
    stg             = "hml"
    staging         = "hml"
    homologacao     = "hml"
    prd             = "prd"
    production      = "prd"
    producao        = "prd"
    sandbox         = "sbx"
  }

  env                      = var.project_env != null ? var.project_env : lookup(local.workspace_map, terraform.workspace, "dev")
  location                 = var.location != null ? var.location : (var.region != null ? var.region : "US")
  terminal_class           = var.autoclass_terminal != null ? var.autoclass_terminal : "NEARLINE"
  public_access_prevention = var.public_prevention == "inherited" ? true : false
  name                     = "sb-${local.env}-${var.name}"

  iam_all_users    = ["allUsers"]
  iam_role_viewer  = "roles/storage.objectViewer"
  iam_role_creator = "roles/storage.objectCreator"
  iam_role_admin   = "roles/storage.objectAdmin"
  iam_members = {
    "${local.iam_role_viewer}"  = var.iam_member_viewer,
    "${local.iam_role_creator}" = var.iam_member_creator,
    "${local.iam_role_admin}"   = var.iam_member_admin
  }
}

# Cria um bucket no Google Cloud Storage
resource "google_storage_bucket" "bucket-storage" {
  name                        = local.name
  location                    = local.location
  project                     = var.project_id
  public_access_prevention    = var.public_prevention
  uniform_bucket_level_access = var.uniform_access
  force_destroy               = var.force_destroy
  storage_class               = var.class

  dynamic "autoclass" {
    for_each = var.autoclass ? { default = 1 } : {}

    content {
      enabled                = var.autoclass
      terminal_storage_class = local.terminal_class
    }
  }

  dynamic "cors" {
    for_each = length(var.cors_origin) > 0 ? { default = 1 } : {}

    content {
      origin          = var.cors_origin
      method          = var.cors_method
      response_header = var.cors_header
      max_age_seconds = var.cors_age
    }
  }

  dynamic "website" {
    for_each = var.website ? { default = 1 } : {}

    content {
      main_page_suffix = var.website_main
      not_found_page   = var.website_error
    }
  }

  labels = merge(
    {
      project     = "${var.project_id}",
      environment = "${local.env}",
      service     = "storage-bucket",
      iac         = "terraform",
      public      = "${var.public_prevention == "enforced" ? true : false}"
    },
    var.labels
  )
}

# Define uma regra de acesso público de leitura para o bucket
resource "google_storage_bucket_iam_binding" "bucket-storage-iam" {
  for_each = var.iam_public ? { default : 1 } : {}

  bucket  = local.name
  role    = local.iam_role_viewer
  members = local.iam_all_users

  depends_on = [
    google_storage_bucket.bucket-storage
  ]
}

# Define uma regra de acesso de ler, criar e administrar a membro para o bucket
resource "google_storage_bucket_iam_binding" "bucket-storage-member" {
  for_each = local.iam_members

  bucket  = local.name
  role    = each.key
  members = each.value

  depends_on = [
    google_storage_bucket.bucket-storage
  ]
}

# Cria uma conta de serviço storage para utilizar nos serviços das APIs
resource "google_service_account" "storage-account" {
  for_each = var.storage_account_create ? { default : 1 } : {}

  account_id   = "storage-account-${var.project_id}"
  display_name = "Storage Account for API Services"
  description  = "Conta de Serviço Storage com permissão de 'Administrador de Objeto do Storage' para uso das APIs para gerenciar arquivos nos buckets"
  project      = var.project_id
  depends_on = [
    google_storage_bucket.bucket-storage
  ]
}

# Define permissão de Administrador de Objeto do Storage
resource "google_project_iam_member" "storage-account-iam" {
  for_each = (var.storage_account_create || var.storage_account_condition) ? { default : 1 } : {}

  project = var.project_id
  role    = var.storage_account_iam_role
  member  = var.storage_account_create ? google_service_account.storage-account[each.key].member : var.storage_account_member

  dynamic "condition" {
    for_each = var.storage_account_condition ? { default : 1 } : {}

    content {
      title       = title(google_storage_bucket.bucket-storage.name)
      description = "Permissão de acesso ao Bucket ${title(google_storage_bucket.bucket-storage.name)}"
      expression  = "resource.name == '${google_storage_bucket.bucket-storage.name}'"
    }
  }

  depends_on = [
    google_storage_bucket.bucket-storage,
    google_service_account.storage-account
  ]
}

# Cria uma chave para a conta de serviço
resource "google_service_account_key" "storage-account-key" {
  for_each = var.storage_account_create ? { default : 1 } : {}

  service_account_id = google_service_account.storage-account[each.key].name
  public_key_type    = var.storage_account_key_public_type
  private_key_type   = var.storage_account_key_private_type

  depends_on = [
    google_service_account.storage-account,
    google_project_iam_member.storage-account-iam
  ]
}

# Exporta a chave para um arquivo .json
resource "local_file" "storage-account-key-export" {
  for_each = var.storage_account_create ? { default : 1 } : {}

  content  = base64decode(google_service_account_key.storage-account-key[each.key].private_key)
  filename = "${path.root}/terraform.${local.env}.storage.account.key.json"

  depends_on = [
    google_service_account_key.storage-account-key
  ]
}

# Armazena a chave privada em um Secret Manager Secret
resource "google_secret_manager_secret" "secret-storage-account-key" {
  for_each = var.storage_account_create ? { default : 1 } : {}

  secret_id = "storage-account-key-${each.key}"
  project   = var.project_id
  replication {
    auto {}
  }

  depends_on = [
    google_service_account_key.storage-account-key
  ]
}

# Armazena a chave privada como uma versão do Secret
resource "google_secret_manager_secret_version" "secret-storage-account-key-version" {
  for_each = var.storage_account_create ? { default : 1 } : {}

  secret      = google_secret_manager_secret.secret-storage-account-key[each.key].id
  secret_data = google_service_account_key.storage-account-key[each.key].private_key

  depends_on = [
    google_secret_manager_secret.secret-storage-account-key
  ]
}
