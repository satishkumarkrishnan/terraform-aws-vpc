terraform {

  cloud {
    organization = "CG_Tokyo"

    workspaces {
      name = "Tokyo-cli"
    }
  }
}