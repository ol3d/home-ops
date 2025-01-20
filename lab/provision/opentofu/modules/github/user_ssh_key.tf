resource "github_user_ssh_key" "ca_key" {
  provider = github.token
  title = "SSH Certificate Authority"
  key = file("/home/deloa6133/.ssh/ca_key.pub")
}
