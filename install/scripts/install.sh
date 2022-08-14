#!/bin/bash

set -e

# Show the user all relevant variables for debugging!
printf "user: ${user}\n"
printf "email: ${email}\n"
printf "repository: ${repository}\n"
printf "release: ${release}\n"
printf "branch: ${branch}\n"
printf "full_clone: ${full_clone}\n"

# This is in the install instructions
git config --global --add user.name "${user}"
git config --global --add user.email  "${email}"

python -m pip install --upgrade pip

# Do we have a release or a branch?
if [ "${release}" != "" ]; then
    printf "Installing datalad from release ${release}...\n"
    wget https://github.com/${repository}/releases/download/v${release}/datalad-${release}.tar.gz
    pip install datalad-${release}.tar.gz

# Branch install, either shallow or full clone
else
    if [[ "${full_clone}" == "false" ]]; then
        printf "Installing datalad from branch ${branch} with full clone...\n"
        git clone --depth 1 -b ${branch} https://github.com/${repository} /tmp/datalad
        cd /tmp/datalad
        pip install .
        cd -
        rm -rf /tmp/datalad
    else
        printf "Installing datalad from branch ${branch}...\n"
        pip install git+https://github.com/${repository}.git@${branch}
    fi
fi
