variable "aws_region" {
  default = "ap-south-1"
}

variable "ecr_repo_name" {
  default = "nodejs-app"
}

variable "ecs_cluster_name" {
  default = "nodejs-cluster"
}

variable "subnet_ids" {
  type = list(string)
  description = "Public subnet IDs for ECS service"
}

variable "security_group_id" {
  description = "Security Group ID with port 3000 open"
}
