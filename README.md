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

Be sure to use the MD5 hash of the SSH key for the TF_VAR_key_id vaiable; not the SHA256 hash. The SHA256 hash is the default printed out by `ssh-keygen` in OpenSSH 6.8 and newer, and is accepted by the [node-triton](https://github.com/joyent/node-triton) tools. If you have these tools installed, there is a good chance that you have the `TRITON_KEY_ID` environment variable set to the SHA256 value for your SSH key.

You can generate the MD5 fingerprint for a SSH key by using the following flags with `ssh-keygen`

```
$ ssh-keygen -l -E md5 -f  ~/.ssh/id_rsa.pub
2048 MD5:db:95:dd:3d:dd:6e:52:69:21:96:2a:46:4a:8d:21:7e example@example.local (RSA)
```

In this example, the SSH key id (fingerprint) is `db:95:dd:3d:dd:6e:52:69:21:96:2a:46:4a:8d:21:7e`.

For comparision, the SHA256 fingerprint will appear as follows:

```
ssh-keygen -l  -f  ~/.ssh/id_rsa.pub
2048 SHA256:8lJK34wkvadR5LNMj5WY4xFktFl/Q5UGcuKBtya9oO4 example@example.local (RSA)
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
