export ANSIBLE_IP=192.168.5.123
export WEB1_IP=192.168.5.11
export WEB2_IP=192.168.5.12
export LB1_IP=192.168.5.99

################################################################################
# それぞれにもしかしたら結構時間がかかるかもしれないので、1行ずつ打ったほうが良いかも
################################################################################
plugin:
	vagrant plugin install vagrant-hosts

up: plugin
	vagrant up

chmod:
	chmod 600 .vagrant/machines/*/virtualbox/private_key

# SSHのオプションとSSH先
# $1：VMマシン名
# $2：VM側のIP
define ssh-option
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	-i .vagrant/machines/$1/virtualbox/private_key \
	vagrant@$2
endef
ansible: chmod
	ssh $(call ssh-option,ansible,${ANSIBLE_IP})
lb1: chmod
	ssh $(call ssh-option,LB1,${LB1_IP})
web1: chmod
	ssh $(call ssh-option,web1,${WEB1_IP})
web2: chmod
	ssh $(call ssh-option,web2,${WEB2_IP})

################################################################################
# Ansible
################################################################################
provision-each-vm:
	ssh $(call ssh-option,ansible,${ANSIBLE_IP}) \
		'cd ansible && make provision'

################################################################################
# Host側で全部できるようにするためにsshでコマンドを送る
################################################################################
setup-lb: chmod
	ssh $(call ssh-option,lb1,${LB1_IP}) \
		"cd lb && make setup-full"
setup-web: chmod
	ssh $(call ssh-option,web1,${WEB1_IP}) \
		"cd web && make setup-full"
	ssh $(call ssh-option,web2,${WEB2_IP}) \
		"cd web && make setup-full"

up-web: chmod
	ssh $(call ssh-option,web1,${WEB1_IP}) \
		"cd web && make up"
	ssh $(call ssh-option,web2,${WEB2_IP}) \
		"cd web && make up"

clean-lb: chmod
	ssh $(call ssh-option,lb1,${LB1_IP}) \
		"cd lb && make clean"
clean-web: chmod
	ssh $(call ssh-option,web1,${WEB1_IP}) \
		"cd web && make clean"
	ssh $(call ssh-option,web2,${WEB2_IP}) \
		"cd web && make clean"

setup-full: chmod
	make setup-lb
	make setup-web

clean-full: chmod
	make clean-lb
	make clean-web
