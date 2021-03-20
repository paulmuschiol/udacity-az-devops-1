variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "count_instances" {
  description = "The amount of vm instance that get deployed in the scale set"
}

variable "location" {
  description = "azure region"
  default = "westeurope"
}

variable "project" {
  description = "project tag that will be added accross all indexed resources"
  default = "udacity-exam-1"
}