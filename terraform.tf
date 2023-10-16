terraform {

  cloud {
    organization = "CG_mumbai"

    workspaces {
      name = "mumbai-cli"
    }
  }
}