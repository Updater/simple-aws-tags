variable "owner_tag" {
  description = "What team (or person if no team exists) is responsible for this resource"
}
variable "environment_tag" {
  description = "What environment is this resource supporting (example: Prod, Staging/Sandbox, Demo)"
}
variable "product_tag" {
  description = "What product is this resource a part of (exmple: UpdaterAPI, InvitePlatform, etc)"
}
variable "feature_tag" {
  description = "What feature of a product does this component support? This is a 'subtag' of product"
  default = ""
}
variable "component_tag" {
  description = "What component of a product is this? This is a 'subtag' of product"
  default = ""
}
variable "division_tag" {
  description = "What division does this resource support (example: Updater, Verical1, UHS, etc)"
}
variable "project_tag" {
  description = "What specific project is this a part of (usually shorter lived than products)"
  default = ""
}
variable "tf_workspace_tag" {
  description = "The terraform cloud/enterprise workspace this resource was created from (example: Updater/core-ops-cons-infra-vault)"
  default = ""
}

locals {
  tags = "${merge(map("Owner", var.owner_tag), map("Environment", var.environment_tag), map("Product", var.product_tag), map("Feature", var.feature_tag), map("Component", var.component_tag), map("Division", var.division_tag), map("Project", var.project_tag), map("TFWorkspace", var.tf_workspace_tag))}"
  ruby_string_tags = "{ 'Owner' => '${var.owner_tag}', 'Environment' => '${var.environment_tag}', 'Product' => '${var.product_tag}', 'Feature' => '${var.feature_tag}', 'Component' => '${var.component_tag}', 'Division' => '${var.division_tag}', 'Project' => '${var.project_tag}', 'TFWorkspace' => '${var.tf_workspace_tag}' }"
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

output "ruby_string_tags" {
  value = "${local.ruby_string_tags}"
}
