variable "project_id" {
  type        = string
  description = "The Google project ID"
}

variable "region" {
  type        = string
  description = "The Google project ID"
}

variable "zone" {
  type        = list(string)
  description = "The Google project ID"
}

variable "gke_num_nodes" {
  type     = number
  description = "number of gke nodes"
}
