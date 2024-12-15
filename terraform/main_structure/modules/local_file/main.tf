resource "local_file" "inventory" {
  content  = var.content
  filename = var.filename
}