# Create instance
resource "hcloud_server" "minecraft" {
  location     = var.location
  server_type  = var.server_type
  image        = var.os_type
  name         = var.hostname
  ssh_keys     = [hcloud_ssh_key.minecraft.id]
  firewall_ids = [hcloud_firewall.firewall.id]
  provisioner "remote-exec" {
    inline = ["echo 'Waiting for server to be initialized...'"]
    connection {
      host  = self.ipv4_address
      type  = "ssh"
      user  = "root"
      agent = true
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' ../ansible/destroy/main.yml"
  }
}

resource "null_resource" "deploy" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${hcloud_server.minecraft.ipv4_address},' ../ansible/deploy/main.yml"
  }
}