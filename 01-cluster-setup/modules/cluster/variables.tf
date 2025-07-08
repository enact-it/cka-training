variable "name" {
  type        = string
  description = "The name to use"
}

variable "public_key" {
  type        = string
  description = "The public SSH key for accessing the control plane"
}
