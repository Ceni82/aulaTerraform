terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "dop_v1_e384d0a6778c64846e4fe1c9edd1a31fc4d03477b083a7699982c7521cef0b2b"
}


# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-22-04-x64"
  name   = "jenkins"
  region = "nyc1"
  size   = "s-2vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.jornada.fingerprint]
}

resource "digitalocean_ssh_key" "jornada" {
  name       = "jornada"
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = "k8s"
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1. 24.4.-do.0"

  node_pool {
    name       = "defoul"
    size       = "s-2vcpu-2gb"
    node_count = 2

   
  }
}