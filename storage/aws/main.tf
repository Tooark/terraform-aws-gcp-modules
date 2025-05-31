resource "aws_s3_bucket" "storage" {
  bucket = "storage-bucket-${var.project_name}"
  dynamic "lifecycle_rule" {
    for_each = var.storage_lifecycle_rule ? [1] : []

    content {
      enabled = var.storage_lifecycle_rule
      transition {
        storage_class = var.transition_storage_class
        days          = var.storage_objects_transition_days
      }
      expiration {
        days = var.storage_objects_expiration_days
      }
    }
  }

  dynamic "website" {
    for_each = var.storage_website ? [1] : []

    content {
      index_document = length(var.storage_index) > 0 ? "${var.storage_index}.html" : var.storage_index
      error_document = var.storage_error_index
    }
  }

  tags = {
    Project     = "${var.project_name}"
    Environment = "${var.project_env}"
    iac         = "terraform"
    service     = "s3"
  }
}

resource "aws_iam_user" "service-user" {
  count = var.user_count

  name = "${var.iam_user_name}-to-s3-${aws_s3_bucket.storage.bucket}-${count.index + 1}"

  tags = {
    Project     = "${var.project_name}"
    Environment = "${var.project_env}"
    iac         = "terraform"
    service     = "iam"
  }
}

resource "aws_iam_access_key" "service-user-key" {
  count = var.user_count

  user = aws_iam_user.service-user[0].name
}
resource "aws_iam_policy" "grant-storage-access" {
  count = var.user_count

  name        = "policy-${aws_s3_bucket.storage.bucket}"
  path        = "/"
  description = "Grant access to storage ${aws_s3_bucket.storage.bucket}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : "s3:*",
        Resource = "arn:aws:s3:::\"${aws_s3_bucket.storage.bucket}\"/*"
      },
    ]
  })

  tags = {
    Project     = "${var.project_name}"
    Environment = "${var.project_env}"
    iac         = "terraform"
    service     = "iam"
  }

  depends_on = [aws_s3_bucket.storage, aws_iam_user.service-user]
}

resource "aws_iam_user_policy_attachment" "grant-users-access-storage" {
  count = var.user_count >= 1 ? 1 : 0

  user       = aws_iam_user.service-user[count.index].name
  policy_arn = aws_iam_policy.grant-storage-access[count.index].arn
}

resource "aws_secretsmanager_secret" "service_user_secret" {
  count = var.user_count

  name = "service-user-secret-${count.index + 1}"
}

resource "aws_secretsmanager_secret_version" "service_user_secret_version" {
  count = var.user_count

  secret_id = aws_secretsmanager_secret.service_user_secret[count.index].id
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.service-user-key[count.index].id,
    secret_access_key = aws_iam_access_key.service-user-key[count.index].secret
  })
}
