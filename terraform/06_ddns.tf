# Change public IP address on DDNS
data "http" "dynudns_domain" {
  count = var.ddns_subdomain == "" ? 1 : 1
  url   = "https://api.dynu.com/nic/update?alias=${var.ddns_subdomain}}&hostname=${var.ddns_hostname}&myip=${hcloud_server.minecraft.ipv4_address}&username=${var.ddns_username}&password=${var.ddns_password}"
}

data "http" "dynudns_subdomain" {
  url = "https://api.dynu.com/nic/update?hostname=${var.ddns_hostname}&myip=${hcloud_server.minecraft.ipv4_address}&username=${var.ddns_username}&password=${var.ddns_password}"
}
