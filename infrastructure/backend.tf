terraform {
  backend "gcs" {
    credentials = "../account/account.json"
  }
}