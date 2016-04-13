bootstrap: vagrant provision

vagrant:
	@vagrant up

provision:
	@ansible-playbook -i plays/inventory/vagrant.py plays/init.yml

destroy:
	@vagrant destroy -f
