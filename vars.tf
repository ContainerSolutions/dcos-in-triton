variable "account" {
  type        = "string"
  description = "Triton username"
}

variable "key_id" {
  type        = "string"
  description = "Fingerprint of the public key matching the key specified in key_path" # More info here https://github.com/hashicorp/terraform/blob/v0.6.14/website/source/docs/providers/triton/index.html.markdown
}

variable "key_path" {
  type        = "string"
  default     = "~/.ssh/id_rsa"
  description = "The full path to the private key of the SSH key pair used in Triton"
}
