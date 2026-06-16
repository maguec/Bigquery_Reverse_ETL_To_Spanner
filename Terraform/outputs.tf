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

#output "vm_ssh_command" {
#  value = "gcloud compute ssh --zone ${var.gcp_zone} vm-${local.suffix} --project ${var.gcp_project_id}${var.enable_external ? "" : " --tunnel-through-iap"}"
#}
