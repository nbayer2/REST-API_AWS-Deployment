resource "aws_ecr_repository" "cloudbootcamp-repo" {
  name                 = "cloudbootcamp_nicolas_bayer_containerregistery"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = false
  }
}   

# terraform import aws_ecr_repository.cloudbootcamp-repo cloudbootcamp_nicolas_bayer_containerregistery