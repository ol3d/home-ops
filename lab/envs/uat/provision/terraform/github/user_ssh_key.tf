resource "github_user_ssh_key" "mgmt-key" {
    provider = github.token
    title = "mgmt"
    key = file("~/.ssh/github_keystore/github-ed25519.pub")
}
