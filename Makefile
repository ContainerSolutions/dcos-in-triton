bootstrap: vagrant provision

vagrant:
	@vagrant up

provision:
	@ansible-playbook -i plays/inventory/vagrant plays/init.yml

destroy:
	@vagrant destroy -f
