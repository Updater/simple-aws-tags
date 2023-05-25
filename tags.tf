variable "owner_tag" {
}

variable "environment_tag" {
}

variable "product_tag" {
}

variable "division_tag" {
}

variable "project_tag" {
  default = ""
}

variable "tf_workspace_tag" {
  default = ""
}

locals {
  tags = merge(
    {
      "Owner" = var.owner_tag
    },
    {
      "Environment" = var.environment_tag
    },
    {
      "Product" = var.product_tag
    },
    {
      "Division" = var.division_tag
    },
    {
      "Project" = var.project_tag
    },
    {
      "TFWorkspace" = var.tf_workspace_tag
    },
  )

  tags_clean = { for k, v in local.tags : k => v if v != "" }

  ruby_string_tags = "{ 'Owner' => '${var.owner_tag}', 'Environment' => '${var.environment_tag}', 'Product' => '${var.product_tag}', 'Division' => '${var.division_tag}', 'Project' => '${var.project_tag}', 'TFWorkspace' => '${var.tf_workspace_tag}' }"

  asg_tags = [
    for k, v in local.tags_clean :
    {
      "key"                 = k
      "value"               = v
      "propagate_at_launch" = "true"
    }
  ]
}

output "asg_tags" {
  value       = local.asg_tags
  description = "Tags as a list of maps for ASGs"
}

output "tags" {
  value = local.tags_clean
}

output "ruby_string_tags" {
  value = local.ruby_string_tags
}

