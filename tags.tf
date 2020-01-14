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
}

# Testing here, will extract to a module once working

data "null_data_source" "asg_tags" {
  count = length(keys(local.tags))

  inputs = merge(
    {
      "key"   = element(keys(local.tags), count.index)
      "value" = element(values(local.tags), count.index)
    },
    {
      "propagate_at_launch" = "true"
    },
  )
}

output "asg_tags" {
  value       = [data.null_data_source.asg_tags.*.outputs]
  description = "Tags as a list of maps for ASGs"
}

output "tags" {
  value = local.tags
}

