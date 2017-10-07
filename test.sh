#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/test.sh
#   - distro: a supported Docker distro version (default = "centos7")
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#
# License: MIT

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
distro=${distro:-"ubuntu1604"}
playbook=${playbook:-"test.yml"}
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}
test_idempotence=${test_idempotence:-"false"}


# Run the container using the supplied OS.
printf ${green}"Starting $distro ansible."${neutral}"\n"
sudo ansible localhost -m file -a "src=/vagrant dest=/etc/ansible/roles/role_under_test state=link"
sudo ansible localhost -m lineinfile -a "line='localhost ansible_connection=local' path=/etc/ansible/hosts state=present"

printf "\n"

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/tests/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  sudo ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml
fi

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
sudo ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: sudo ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook"${neutral}
sudo ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook -vvv --connection=local

if [ "$test_idempotence" = true ]; then
  # Run Ansible playbook again (idempotence test).
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  sudo ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook -vvv --connection=local | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

sudo ansible localhost -m file -a "src=./ dest=/etc/ansible/roles/role_under_test state=absent"
sudo ansible localhost -m lineinfile -a "line='localhost ansible_connection=local' path=/etc/ansible/hosts state=absent"