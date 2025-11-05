resource "scaleway_object_bucket" "seemyping-xyz-staticfiles" {
  name   = var.bucket_name
  region = "fr-par"
  tags = {
    managed_by = "terraform"
  }
}

resource "scaleway_object_bucket_acl" "seemyping-xyz-staticfiles" {
  bucket = scaleway_object_bucket.seemyping-xyz-staticfiles.id
  acl    = "private"
}

resource "scaleway_object_bucket_policy" "policy" {
  bucket = scaleway_object_bucket.seemyping-xyz-staticfiles.id
  policy = jsonencode({
    Id = "policy"
    Statement = [
      {
        Action = "*"
        Effect = "Allow"
        Principal = {
          SCW = [
            "application_id:${scaleway_iam_application.seemyping-webapp.id}"
          ]
        }
        Resource = [
          var.bucket_name,
          "${var.bucket_name}/*"
        ]
        Sid = ""
      },
      {
        Action = "*"
        Effect = "Allow"
        Principal = {
          SCW = [
            "user_id:${data.scaleway_iam_user.nawer.id}"
          ]
        }
        Resource = [
          var.bucket_name,
          "${var.bucket_name}/*"
        ]
        Sid = "Scaleway secure statement"
      }
    ]
    Version = "2023-04-17"
  })
}