# Add SSH key
resource "hcloud_ssh_key" "minecraft" {
  name       = var.hostname
  public_key = file("~/.ssh/${var.hostname}.pub")
}
