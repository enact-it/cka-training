variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "public_keys" {
  description = "Map of names to SSH public keys"
  type        = map(string)
}
