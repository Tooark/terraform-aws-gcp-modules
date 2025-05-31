output "resource_bucket_storage" {
  value = {
    id            = aws_s3_bucket.storage.id
    name          = aws_s3_bucket.storage.bucket
    url           = "https://${aws_s3_bucket.storage.bucket}.s3.amazonaws.com"
    storage_class = flatten([for transition in aws_s3_bucket.storage.lifecycle_rule : [transition.storage_class]])
    tags          = aws_s3_bucket.storage.tags
  }
  description = "Dados do Storage Bucket"
}

output "resource_bucket_storage_iam" {
  value = [for storage in aws_iam_policy.grant-storage-access : {
    name            = storage.name
    policy_resource = storage.policy
    users           = [for users in aws_iam_user_policy_attachment.grant-users-access-storage : users.user if users.policy_arn == storage.arn]
  }]
  description = "Politicas de acesso ao storage bucket"
}
output "users_attached_on_s3" {
  value = [for user in aws_iam_user_policy_attachment.grant-users-access-storage : {
    user   = user.user
    policy = user.policy_arn
  }]
}
output "storage_id" {
  value       = aws_s3_bucket.storage.id
  description = "Id do Storage Bucket"
}
output "storage_region" {
  value       = aws_s3_bucket.storage.region
  description = "Regiao do Storage Bucket"
}
output "storage_name" {
  value       = aws_s3_bucket.storage.bucket
  description = "Nome do Storage Bucket"
}
output "storage_arn" {
  value       = aws_s3_bucket.storage.arn
  description = "Arn do Storage bucket"
}
# output "storage_object_class" {
#   value       = flatten([for transition in aws_s3_bucket.storage.lifecycle_rule : [transition.storage_class]])[0]
#   description = "Tipo de classe para objetos do Storage Bucket"
# }
output "storage_policy" {
  value       = [for name in aws_iam_policy.grant-storage-access : name.name]
  description = "Nome da politica de acesso ao Storage Bucket"
}
output "storage_service_user_name" {
  value       = { for k, user in aws_iam_user.service-user : k => user.name }
  description = "Nome do usuario de servico com acesso ao Sotrage Bucket"
}
output "iam_storage_service_user_arn" {
  value       = { for i, user in aws_iam_user.service-user : i => user.arn }
  description = "Arn do usuario de servico com acesso ao Storage Bucket"
}
output "iam_storage_service_user_key" {
  value       = aws_iam_access_key.service-user-key
  sensitive   = true
  description = "Chave de usuario do usuario de servico"
}
output "count_users_atached_on_storage_policy" {
  value       = [for users in aws_iam_user_policy_attachment.grant-users-access-storage : users.user]
  description = "Quantidade de usuarios com acesso ao Storage Bucket"
}
output "users_with_permission_on_this_storage" {
  value       = [for users in aws_iam_user_policy_attachment.grant-users-access-storage : users.user]
  description = "Nome dos usuarios com acesso ao Storage Bucket"
}
