resource "google_project_service" "spanner" {
  project                    = var.gcp_project_id
  service                    = "spanner.googleapis.com"
  disable_dependent_services = var.disable_apis
  disable_on_destroy         = var.disable_apis
}

resource "google_spanner_instance" "spanner_instance" {
  name                         = "spanner-${local.suffix}"
  config                       = "regional-${var.gcp_region}"
  display_name                 = "spanner-${local.suffix}"
  project                      = var.gcp_project_id
  processing_units             = 100
  default_backup_schedule_type = "NONE"
  depends_on                   = [google_project_service.spanner]
}

resource "google_spanner_database" "spanner_db" {
  instance = google_spanner_instance.spanner_instance.name
  name     = "db_${local.suffix}"
  project  = var.gcp_project_id
}

resource "google_bigquery_connection" "spanner_connection" {
  connection_id = "spanner_connection_${local.suffix}"
  project       = var.gcp_project_id
  location      = var.location
  friendly_name = "spanner_connection_${local.suffix}"
  description   = "BigQuery Connection to Cloud Spanner for Reverse ETL"

  cloud_resource {}

  depends_on = [
    google_project_service.spanner,
    google_project_service.bqconnection
  ]
}

resource "google_spanner_database_iam_member" "spanner_bq_access" {
  instance = google_spanner_instance.spanner_instance.name
  database = google_spanner_database.spanner_db.name
  role     = "roles/spanner.databaseUser"
  member   = "serviceAccount:${google_bigquery_connection.spanner_connection.cloud_resource[0].service_account_id}"
}

output "spanner_instance_id" {
  value       = google_spanner_instance.spanner_instance.id
  description = "The ID of the Spanner instance created"
}

output "spanner_database_id" {
  value       = google_spanner_database.spanner_db.id
  description = "The ID of the Spanner database created"
}

output "bq_spanner_connection_id" {
  value       = google_bigquery_connection.spanner_connection.id
  description = "The ID of the BigQuery connection to Spanner"
}
