provider "hcloud" {
  token = var.hcloud_token
}


module "student_cluster" {
  for_each   = var.public_keys
  source     = "./modules/cluster"
  name       = each.key
  public_key = each.value
}
