resource "google_bigquery_dataset" "bq" {
  project                     = var.gcp_project_id
  dataset_id                  = "data_${local.suffix}"
  friendly_name               = "data_${local.suffix}"
  description                 = "A Dataset we created to play nice with data-${local.suffix}"
  location                    = var.location
  default_table_expiration_ms = 3600000

  labels = {
    id = "${local.suffix}"
  }

}

resource "google_bigquery_reservation" "reservation" {
  name              = "bq-reservation-${local.suffix}"
  location          = var.location
  slot_capacity     = 50
  edition           = "ENTERPRISE"
  ignore_idle_slots = true
  concurrency       = 0
  autoscale {
    max_slots = 50
  }
}

resource "google_bigquery_reservation_assignment" "assignment" {
  project     = var.gcp_project_id
  location    = var.location
  reservation = google_bigquery_reservation.reservation.id
  assignee    = "projects/${var.gcp_project_id}"
  job_type    = "QUERY"
}
