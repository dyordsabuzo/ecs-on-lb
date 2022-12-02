locals {
  app_list = {
    myngix = {
      image = "nginx:latest"
      port  = 80
    }
    myjackett = {
      image = "lscr.io/linuxserver/jackett:latest"
      port  = 9117
    }
  }

  base_domain = "pablosspot.ml"
}
