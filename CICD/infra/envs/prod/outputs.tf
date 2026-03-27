output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "codepipeline_name" {
  value = module.codepipeline.pipeline_name
}

output "codebuild_project_name" {
  value = module.codebuild.project_name
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}
