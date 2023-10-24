terraform {
  backend "gcs" {
    bucket = "tf-stage-wms-mailbox-state-owfse"
    prefix = "stage/services/mailbox"
  }
}