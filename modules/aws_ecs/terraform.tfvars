environment = "agd-dev"
agd_ecs = "agd-ecs"
nginx_task    = "arn:aws:ecs:region:account-id:task-definition/nginx-task:1"
subnets       = ["subnet-0717aac9526c9ff4b", "subnet-00f809b073695b201"]
security_groups = ["mi-cluster-agd-node", "mi-cluster-agd-cluster"]