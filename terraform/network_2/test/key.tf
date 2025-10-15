# Generate SSH key pair
resource "tls_private_key" "ssh_key" {
 algorithm = "RSA"
 rsa_bits  = 4096
}
# Save private key locally (for SSH client use)
resource "local_file" "private_key" {
 content         = tls_private_key.ssh_key.private_key_pem
 filename        = "${path.module}/.ssh/gcp_ssh_key.pem"
 file_permission = "0600"
}
# Save public key locally (for reference)
resource "local_file" "public_key" {
 content  = tls_private_key.ssh_key.public_key_openssh
 filename = "${path.module}/.ssh/gcp_ssh_key.pub"
 file_permission = "0644"
}