#!/bin/bash -eu

usage_error() {
    echo "Usage: $0 <instance_name>" >&2
    exit 1
}

if [ "${#}" -ne 1 ] ; then
    usage_error
fi

dir=$(dirname "$0")
# Need to use two different files because the backend is picky about
# variables it does not know about. The two files are of different "type"
# because backend initialization doesn't automatically recognize "auto"
# variables.
backend_vars_name=tf-backend.tfvars
root_autovars_name=server-name.auto.tfvars
backend_vars_file=${dir}/${backend_vars_name}
root_autovars_file=${dir}/${root_autovars_name}

echo 'state_name = "'"${1}"'.tfstate"' >"${backend_vars_file}"
echo 'instance_name = "'"${1}"'"' >"${root_autovars_file}"
echo 'Call: terraform init [-reconfigure] -backend-config='"${backend_vars_name}"
