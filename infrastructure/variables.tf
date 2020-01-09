variable "region" {
  description = "The region where your instance will be located."
  type    = "string"
  default = "us-central1"
}

variable "zone" {
  description = "The region where your resources will be located."
  type    = "string"
  default = "us-central1-b"
}

variable "project" {
  description = "The id of your project"
}

variable "ip_address" {
  type = "string"
  description = "Facilitates communication between the instance and other resources on the network (computed for this app)"
}

variable "database_name" {
  type = "string"
  description="name of configured database"
}
variable "database_user" {
  type = "string"
  description = "database user"
}
variable "database_password" {
  type = "string"
  description = "database password"
}
variable "postgres_ip" {
  type = "string"
  description="postgres ip"
}

variable "gs_bucket" {
  type = "string"
  description="GCP storage bucket for your images"
}

variable "gs_bucket_url" {
  type = "string"
  description="Url for the bucket"
}

variable "django_environment" {
  type="string"
}

variable "environment" {
  type="string"
  default="integration"
}

variable "network" {
  type="string"
  default="default"
}

variable "application_host" {
  type="string"
}

variable "github_branch" {
  type="string"
  default="develop"
}

variable "machine_type" {
  type="string"
  default="f1-micro"
}

variable "compute_instance_name" {
  type="string"
}

variable "image_name" {
  type="string"
}

variable "twilio_account_sid" {
  type="string"
}

variable "twilio_auth_token" {
  type="string"
}

variable "email_host" {
  type="string"
}

variable "email_host_user" {
  type="string"
}

variable "email_host_password" {
  type="string"
}

variable "google_application_credentials" {
  type="string"
}

variable "gs_credentials" {

}


