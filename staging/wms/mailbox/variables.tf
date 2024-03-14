variable "project_id" {
  type        = string
  description = "The Google project ID"
}

variable "region" {
  type        = string
  description = "The Google project ID"
}

variable "service_name" {
  type = string
  description = "postgres password"
}

variable "vault_address" {
  type = string
  description = "vault address"
}

variable "vault_token" {
  type = string
  description = "vault token"
}