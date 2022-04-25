#!/bin/sh

vagrant up --no-provision && vagrant provision | tee "setup_log"
