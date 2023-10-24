terraform {
  backend "gcs" {
    bucket = "tf-stage-wms-common-state-pwkln"
    prefix = "stage/services/wms"
  }
}