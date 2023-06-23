all: vagrant k3s k8s-bootstrap configure-vault configure-boundary waypoint kubedoom

all-packer: packer vagrant k3s k8s-bootstrap configure-vault configure-boundary waypoint kubedoom

packer:
	cd 0-packer/ && make build import

vagrant:
	cd 1-vagrant/ && make

k3s:
	cd 2-k3s/ && make

k8s-bootstrap:
	sleep 5
	cd 3-k8s-bootstrap/ && make && make unseal

configure-vault:
	cd 4-configure-vault/ && make

configure-boundary:
	cd 5-configure-boundary/ && make

waypoint:
	cd 6-waypoint/ && make

kubedoom:
	cd 7-kubedoom/ && make login init up

destroy:
	cd 1-vagrant/ && make destroy