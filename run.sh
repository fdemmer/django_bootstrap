#/bin/bash

until [[ ${service_name} =~ ^[a-z0-9]+$ ]]; do
	read -p $'Choose a service name. Please use only numbers and letters:\n> ' service_name
done

# determine script directory and go there
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}

# set service_name
sed -i -e 's/service_name = "myproject"/service_name = "'${service_name}'"/g' Vagrantfile

# remove bootstrap git
rm -rf ./.git

# init new git
git init
git commit -am "Initial commit"

# run vagrant
vagrant up

# self destruct
rm ${BASH_SOURCE[0]}
