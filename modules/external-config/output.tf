output "services_config" {
  value = {
    service_type = "external-google"
    config = {
      installation_type = {
        value = "production"
      }

      production_type = {
        value = "external"
      }

      pg_user = {
        value = var.postgresql_user
      }

      pg_password = {
        value = var.postgresql_password
      }

      pg_netloc = {
        value = var.postgresql_address
      }

      pg_dbname = {
        value = var.postgresql_database
      }

      pg_extra_params = {
        value = var.postgresql_extra_params
      }

      placement = {
        value = "placement_gcs"
      }

      gcs_credentials = {
        # This is required because when we use the value later, it needs to be one line otherwise
        # the templating breaks inside kubernetes. That should be addressed as well, but until then
        # we do it here.
        value = replace(var.gcs_credentials, "\n", "")
      }

      gcs_project = {
        value = var.gcs_project
      }

      gcs_bucket = {
        value = var.gcs_bucket
      }
    }
  }
}
