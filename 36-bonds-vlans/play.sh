#!/bin/bash

ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

# tags
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --list-tags
