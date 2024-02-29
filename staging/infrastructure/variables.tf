variable "project_id" {
  type        = string
  description = "The Google project ID"
}

variable "project_name" {
  type        = string
  description = "The Google project name"
}

variable "region" {
  type        = string
  description = "The Google project ID"
}

variable "zone" {
  type        = string
  description = "The Google project ID"
}

variable "gke_num_nodes" {
  type     = number
  description = "number of gke nodes"
}

variable "pg_username" {
  type = string
  description = "postgres username"
}

variable "pg_password" {
  type = string
  description = "postgres password"
}