#!/bin/bash

ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

# tags
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory --list-tags

# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t routers
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t web
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t nginx

# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t mysql
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t mysql --skip-tags web


# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t web --skip-tags skip_wp_semanage
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t web --start-at-task="install utils" --skip-tags skip_wp_semanage
# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t routers,web --skip-tags skip_wp_semanage

# ansible-playbook site.yml -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory -t routers --start-at-task="copy iptables config"
