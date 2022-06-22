variable "project" {
  description = "ID of the project"
  type        = string
}
variable "region" {
  description = "Name of the region"
  type        = string
}
variable "zone" {
  description = "Name of the zone"
  type        = string
}
variable "auto_repair" {
  description = "it can be true or false"
  type        = bool
}
variable "auto_upgrade" {
  description = "it can be true or false"
  type        = bool
}