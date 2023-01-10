resource "aws_ssm_parameter" "parameter" {
  name  = "/SAMPLE_VAR"
  type  = "SecureString"
  value = "SAMPLE VARIABLE"
}

module "pablosspot-ecs" {
  source = "app.terraform.io/pablosspot/pablosspot-ecs/aws"
  # version  = "0.12.1"
  for_each = local.app_list
  # insert required variables here
  cluster_name = each.key
  service_name = each.key
  task_family  = each.key
  attach_to_lb = false

  launch_type = {
    type   = "FARGATE"
    cpu    = 256
    memory = 512
  }

  container_definitions = jsonencode([{
    name           = each.key
    image          = each.value.image
    container_port = each.value.port
    secrets        = each.value.secrets
  }])
}

# module "pablosspot-lb" {
#   source  = "app.terraform.io/pablosspot/pablosspot-lb/aws"
#   version = "0.0.4"
#   # insert required variables here

#   base_domain = local.base_domain
#   system_name = "generic"
#   endpoints   = [for key, value in local.app_list : key]
# }

# resource "aws_lb_listener_rule" "rule" {
#   for_each     = local.app_list
#   listener_arn = module.pablosspot-lb.lb_listener_arn

#   condition {
#     host_header {
#       values = ["${each.key}.${local.base_domain}"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = module.pablosspot-ecs[each.key].target_group_arn
#   }
# }
