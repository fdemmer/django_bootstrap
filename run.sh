#/bin/bash

# determine script directory and go there
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}

# remove bootstrap git
rm -rf ./.git

# init new git
git init
git commit -am "Initial commit"

# run vagrant
vagrant up

# self destruct
rm ${BASH_SOURCE[0]}
