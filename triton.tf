provider "triton" {
  account      = "${var.account}"
  key_id       = "${var.key_id}"
  key_material = "${file(var.key_path)}"
}

resource "triton_machine" "bootstrap" {
  count   = 1
  name    = "${format(\"bootstrap-%03d\", count.index + 1)}"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-highmemory-17.125-kvm"
}
