# Root terraform variables

variable "location" {
  type        = string
  description = "The name of the target location"
}

variable "location_suffix" {
  type        = string
  description = "The short name of target location. Used to name resources"
}

variable "env" {
  type        = string
  description = "The short name of the target env (i.e. dev, staging, or prod)"
}

variable "app" {
  type        = string
  description = "The short name of the service"
}

variable "acr" {
  type        = string
  description = "Azure Container Registry name"
}

variable "acr_rg" {
  type        = string
  description = "Azure Container Registry resource group name"
}

variable "tag" {
  type        = map(string)
  description = "resource deployment tags"
  default     = {}
}
