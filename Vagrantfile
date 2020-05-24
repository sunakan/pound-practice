# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'
VAGRANT_BOX_UBUNTU  = 'bento/ubuntu-18.04'
VAGRANT_BOX_DEFAULT = VAGRANT_BOX_UBUNTU

vm_specs = [
  { name: 'lb1',  ip: '192.168.5.99', cpus: 1, memory: 512*2, sync_dir: 'lb' },
  { name: 'web1', ip: '192.168.5.11', cpus: 1, memory: 512*2, sync_dir: 'web' },
  { name: 'web2', ip: '192.168.5.12', cpus: 1, memory: 512*2, sync_dir: 'web' },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ##############################################################################
  # 共通
  ##############################################################################
  config.vm.synced_folder '.', '/vagrant', disabled: true

  ##############################################################################
  # 各VM
  ##############################################################################
  vm_specs.each do |spec|
    config.vm.define spec[:name] do |machine|
      machine.vm.box      = spec[:vagrant_box] || VAGRANT_BOX_DEFAULT
      machine.vm.hostname = spec[:name]
      machine.vm.network 'private_network', ip: spec[:ip]
      machine.vm.provider :virtualbox do |vb|
        vb.name   = "#{Pathname.pwd.basename}-#{spec[:name]}"
        vb.cpus   = spec[:cpus]
        vb.memory = spec[:memory]
      end
      if dir = spec[:sync_dir]
        machine.vm.synced_folder "./#{dir}", "/home/vagrant/#{dir}",
          create: true, type: :rsync, owner: :vagrant, group: :vagrant,
          rsync__exclude: ['*.swp', '.git/', '.idea*', '*.iml']
      end
    end
  end

  ##############################################################################
  # Ansibleをするためだけの初期化用VM（なくてもいい）
  ##############################################################################
  config.vm.define :ansible do |machine|
    machine.vm.box      = VAGRANT_BOX_DEFAULT
    machine.vm.hostname = 'ansible'
    machine.vm.network 'private_network', ip: '192.168.5.123'
    machine.vm.provider :virtualbox do |vb|
      vb.gui    = false
      vb.name   = machine.vm.hostname + '-lb-practice'
      vb.memory = 512 * 2
      vb.cpus   = 1
    end
    machine.vm.provision 'shell', privileged: false, inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install --assume-yes python3-pip make sshpass
      pip3 install --user ansible
    SHELL
    machine.vm.synced_folder './ansible', '/home/vagrant/ansible',
      create: true, type: :rsync, owner: :vagrant, group: :vagrant,
      rsync__exclude: ['*.swp', '.git/']
  end

  ##############################################################################
  # 共通：vagrant-hosts pluginで各VM同士がhost名でアクセス可能（なくてもいい）
  ##############################################################################
  config.vm.provision :hosts, sync_hosts: true
end
