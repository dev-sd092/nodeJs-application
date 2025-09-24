output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.app_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.app_service.name
}
