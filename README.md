# simple-aws-tags
Basic tags for use with aws terraform resources

## What type of resources can be tagged
aws_security_group

aws_elb

aws_alb

aws_autoscaling_group

aws_s3_bucket

aws_cloudfront_distribution

aws_vpc

aws_subnet

aws_network_interface

aws_db_instance

etc..

This list is not exhaustive but is an example of resources that are taggable. 
In order to determine if the resource you are using is taggable check https://www.terraform.io/docs/providers/aws/index.html and see if your resource has a tags variable

## How do I use this module to tag things
First you need to invoke the module

```
module "tags" {
  source = "git::git@github.com:Updater/simple-aws-tags.git"
  environment_tag = "${var.environment_tag}"
  owner_tag = "${var.owner_tag}"
  product_tag = "product-tag-value"
  division_tag = "${var.division_tag}"
  tf_workspace_tag = "${var.tf_workspace_tag}"
}
```

If you need to pass tags into a module it is suggested you pass in both a tags map and an asg-tags list of maps
```
  tags = "${module.tags.tags}"
  asg_tags = "${module.tags.asg_tags}"
```

If you need to merge tags specific to your apps/modules with these required cost tags you may do so in this manner
```
  tags = "${merge(var.tags, map("Name", "Name Tag Value"), map("Project", "Project Tag Value"))}"
```
For autoscaling groups this looks slightly different
```
  tags = [
  {
    key                 = "Name"
    value               = "Name Tag Value"
    propagate_at_launch = true
  },
  {
    key                 = "Project"
    value               = "Project Tag Value"
    propagate_at_launch = true
  }
  ]

  tags = ["${var.asg_tags}"]
  ```
