#!/bin/bash

labauto ansible
ansible-pull -i localhost, -U https://github.com/jkesarwani123/roboshop-INFRA-ansible.git roboshop.yml -e role_name=${name} -e env=${env} &>>/opt/ansible.log