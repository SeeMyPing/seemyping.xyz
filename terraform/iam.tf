resource "scaleway_iam_application" "seemyping-webapp" {
  name = "SeeMyPing-webapp"
}

resource "scaleway_iam_api_key" "seemyping" {
  application_id = scaleway_iam_application.seemyping-webapp.id
  description    = "SeeMyPing webapp IAM"
}

resource "scaleway_iam_policy" "policy" {
  name    = "object-storage-policy"
  application_id  = scaleway_iam_application.seemyping-webapp.id
  rule {
    project_ids          = [scaleway_account_project.seemyping-xyz.id]
    permission_set_names = ["ObjectStorageObjectsRead", "ObjectStorageObjectsWrite"]
  }
}