#!/bin/bash

case "$1" in
  start)
    cd ../docs/
    python -m SimpleHTTPServer &
    ;;
  provision)
    ansible-galaxy install SoInteractive.docker,0.9.0 -p roles
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook site.yml
    ;;
  stop)
    ansible-playbook site.yml -e go=absent
    rm -rf roles
    kill `ps aux | grep python | grep SimpleHTTPServer | awk -F ' ' '{print $2}'`
    ;;
  *)
    sed 's/-docker ansible_host=/.pub ---> /g' INVENTORY
    ;;
esac
