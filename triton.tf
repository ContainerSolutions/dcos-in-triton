provider "triton" {
  account      = "${var.account}"
  key_id       = "${var.key_id}"
  key_material = "${file(var.key_path)}"
}

resource "triton_machine" "dcos-bootstrap" {
  count   = 1
  name    = "dcos-bootstrap"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-2-kvm"

  tags {
    role = "bootstrap"
  }

  connection {
    host = "${triton_machine.dcos-bootstrap.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}

resource "triton_machine" "dcos-master" {
  count   = 1
  name    = "${format(\"dcos-master-%03d\", count.index + 1)}"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-2-kvm"

  tags {
    role = "master"
  }

  connection {
    host = "${triton_machine.dcos-bootstrap.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}

resource "triton_machine" "dcos-agent" {
  count   = 1
  name    = "${format(\"dcos-agent-%03d\", count.index + 1)}"
  image   = "d8e65ea2-1f3e-11e5-8557-6b43e0a88b38"
  package = "g3-standard-2-kvm"

  tags {
    role = "agent"
  }

  connection {
    host = "${triton_machine.dcos-bootstrap.primaryip}"
    private_key = "${file(var.key_path)}"
  }

  provisioner "remote-exec" {
    inline = ["/bin/true"]
  }
}

resource "null_resource" "init" {
  depends_on = ["triton_machine.dcos-bootstrap", "triton_machine.dcos-master", "triton_machine.dcos-agent"]
  provisioner "local-exec" {
    command = "ansible-playbook plays/init.yml -u root -i script.rb"
  }
}
