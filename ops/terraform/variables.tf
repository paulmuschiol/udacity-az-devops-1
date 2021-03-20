variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "pmu"
}

variable "count_instances" {
  description = "The amount of vm instance that get deployed in the scale set"
  default = 2
}

variable "location" {
  description = "azure region"
  default = "westeurope"
}

variable "project" {
  description = "project tag that will be added accross all indexed resources"
  default = "udacity-exam-1"
}

variable "image_id" {
  description = "your image id in azure. Can be retrieved by 'az image list -g RESOURCE_GROUP'"
  
}