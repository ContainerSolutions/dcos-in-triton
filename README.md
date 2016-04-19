# OpenDCOS in Triton
Collection of Terraform configuration files and Ansible playbooks for setting up
OpenDCOS in Triton.

# Requirements
  * [Ansible](https://www.ansible.com) (`>= 2.0.0.2`)
  * [Terraform](https://www.terraform.io/) (`>= 0.6.14`)
  * [Ruby](https://www.ruby-lang.org/en/) (`>= 2.0.0`)

# How to use it?
Clone this repository with
```
git clone https://github.com/ContainerSolutions/dcos-in-triton.git
```

Then you will need to setup some environment variables with your Triton credentials,
including your account, SSH key id and the path to the SSH key:
```
$ export TF_VAR_account=accountname
$ export TF_VAR_key_id=yourkeyid
$ export TF_VAR_key_path=/path/to/ssh/key # (defaults to ~/.ssh/id_rsa)
```

You can check out the Terraform plan with:
```
$ terraform plan
```

Create the infrastructure in Triton with the following command:
```
$ terraform apply
```

Once Terraform is done creating your infrastructure, apply the Ansible roles running the `init.yml` playbook like so:
```
$ ansible-playbook -i plays/inventory/terraform plays/init.yml
```

Finally, find the IP of your DCOS master node by running
```
./plays/inventory/terraform
```

Access that IP on your browser and follow the instructions.

Enjoy!
