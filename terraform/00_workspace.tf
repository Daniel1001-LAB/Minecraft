terraform {
  cloud {
    organization = "HectorCraftx"

    workspaces {
      tags = ["calvaland"]
    }
  }
}
