variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "count_instances" {
  description = "The amount of vm instance that get deployed in the scale set"
}

variable "location" {
  description = "azure region"
  default = "Western Europe"
}