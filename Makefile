bootstrap: vagrant provision

vagrant:
	@vagrant up

provision:
	@ansible-playbook -i ./plays/inventory/vagrant plays/triton.yml

destroy:
	@vagrant destroy -f
