#!/bin/bash

ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

# tags
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --list-tags

# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t routers
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t web
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t nginx
