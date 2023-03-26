start:
	vagrant up

destroy:
	vagrant destroy -f

restart: destroy start

run:
	nomad run -detach k3s.nomad

stop:
	nomad stop -purge k3s