locals {
  basename = "${var.app}-${var.service}-${var.env}"

  default_tags = {
    app = var.app
    service = var.service
    env = var.env
    crew = var.crew
  }
}
