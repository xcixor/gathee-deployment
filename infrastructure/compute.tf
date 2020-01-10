data "google_compute_zones" "available" {}

resource "google_compute_instance" "name" {
  project      = "${var.project}"
  zone         = "${var.zone}"
  name         = "${var.compute_instance_name}"
  machine_type = "${var.machine_type}"
  tags = ["${var.compute_instance_name}-https-firewall", "${var.compute_instance_name}-ssh-firewall", "${var.compute_instance_name}-http-firewall"]

  boot_disk {
    initialize_params {
      image = "${var.image_name}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${var.ip_address}"
      network_tier = "PREMIUM"
    }
  }

  metadata_startup_script = "${file("deploy.sh")}"

  metadata = {
    ip_address    = "${var.ip_address}"
    database_name = "${var.database_name}"
    database_user         = "${var.database_user}"
    database_password     = "${var.database_password}"
    postgres_ip   = "${var.postgres_ip}"
    gs_bucket = "${var.gs_bucket}"
    gs_bucket_url = "${var.gs_bucket_url}"
    django_environment = "${var.django_environment}"
    application_host = "${var.application_host}"
    github_branch = "${var.github_branch}"
    twilio_account_sid = "${var.twilio_account_sid}"
    twilio_auth_token = "${var.twilio_auth_token}"
    email_host = "${var.email_host}"
    email_host_user = "${var.email_host_user}"
    email_host_password = "${var.email_host_password}"
    gs_credentials = "${file("../account/account.json")}"
  }

  # service_account {
  #   email = "${google_service_account.name.email}"
  #   scopes = ["storage-full"]
  # }

}

# resource "google_service_account" "name" {
#   account_id   = "${var.compute_instance_name}"
#   display_name = "${var.compute_instance_name}"
#   name         = "${var.compute_instance_name}"
# }
