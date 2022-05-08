terraform {
  cloud {
    organization = "HectorCraftx"

    workspaces {
      tags = ["mineway"]
    }
  }
}
