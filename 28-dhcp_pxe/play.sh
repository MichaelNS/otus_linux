#!/bin/bash

ansible-playbook -i provisioning/hosts provisioning/playbook.yml -t base

# tags
# ansible-playbook -i provisioning/hosts provisioning/playbook.yml --list-tags
# ansible-playbook -i provisioning/hosts provisioning/playbook.yml -t base
# ansible-playbook -i provisioning/hosts provisioning/playbook.yml -t pxeserver
