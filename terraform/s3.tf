resource "scaleway_object_bucket" "seemyping-xyz-staticfiles" {
  name          = var.bucket_name
  region        = "fr-par"
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
  policy = jsonencode(
    {
      Version = "2023-04-17",
      Statement = [
        {
          Sid    = "Delegate rw access",
          Effect = "Allow",
          Principal = {
            SCW = "application_id:${scaleway_iam_application.seemyping-webapp.id}"
          },
          Action = [
            "s3:GetObject",
            "s3:ListBucket",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = [
            "${scaleway_object_bucket.seemyping-xyz-staticfiles.name}",
            "${scaleway_object_bucket.seemyping-xyz-staticfiles.name}/*"
          ]
        }
      ]
    }
  )
}