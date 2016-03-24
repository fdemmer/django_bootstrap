#!/bin/bash
#
# run ansible tasks with the given tags (including disabled_by_default)
#
# Usage:
#
#   ./provision_tag.sh <tag>[,<tag>]
#
# The Vagrantfile must pass the environment variable ANSIBLE_ARGS to
# ansible.raw_arguments:
#
#   ansible.raw_arguments = Shellwords.shellsplit(ENV['ANSIBLE_ARGS']) if ENV['ANSIBLE_ARGS']
#

export ANSIBLE_ARGS="--tags=$1 --extra-vars='{\"disabled_by_default\": false}'"
vagrant provision
