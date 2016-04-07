bootstrap: vagrant provision

vagrant:
	@vagrant up

provision:
	@ansible-playbook -i plays/inventory/vagrant.py plays/triton.yml

destroy:
	@vagrant destroy -f
