variable "owner_tag" {}
variable "environment_tag" {}
variable "product_tag" {}
variable "division_tag" {}
variable "project_tag" {
  default = ""
}
variable "tf_workspace_tag" {
  default = ""
}

locals {
  tags = "${merge(map("Owner", var.owner_tag), map("Environment", var.environment_tag), map("Product", var.product_tag), map("Division", var.division_tag), map("Project", var.project_tag), map("TFWorkspace", var.tf_workspace_tag))}"
}


# Testing here, will extract to a module once working

data "null_data_source" "asg_tags" {
  count = "${length(keys(local.tags))}"

  inputs = "${merge(map(
    "key", "${element(keys(local.tags), count.index)}",
    "value", "${element(values(local.tags), count.index)}"
  ),
  map("propagate_at_launch", "true"))
  }"
}

output "asg_tags" {
  value       = ["${data.null_data_source.asg_tags.*.outputs}"]
  description = "Tags as a list of maps for ASGs"
}

output "tags" {
  value = "${local.tags}"
}
