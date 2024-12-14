# terraform init && terraform apply --auto-approve && mv s3_backend s3_backend.tf && mv local.tf local && terraform init -migrate-state -force-copy

mv local local.tf && mv s3_backend.tf s3_backend && terraform init -migrate-state -force-copy && terraform destroy --auto-approve

