#!/bin/bash

# Change the prefix is required.
# It has to be compliant with sed command, line 14
secret_prefix="secret:"

# load the secrets
for i in $(printenv | grep ${secret_prefix})
do
  key=$(echo ${i} | cut -d'=' -f 1)
  val=$(echo ${i} | cut -d'=' -f 2-)
  if [[ ${val} == ${secret_prefix}* ]]
  then
    val=$(echo ${val} | sed -e "s/${secret_prefix}//g")
    # Pattern of a secret projectId/secretName#version
    # projectId is optional but / required
    # version and # are optional
    # Example of valid secret
    # /my_secret
    # /my_secret#1
    # /my_secret#latest
    # projectID/my_secret
    # projectID/my_secret#2
    projectId=$(echo ${val} | cut -d'/' -f 1)
    secret=$(echo ${val} | cut -d'/' -f 2)

    if [[ -n ${projectId} ]]
    then
      project="--project=${projectId}"
    fi

    secretName=$(echo ${secret} | cut -d'#' -f 1)
    version="latest"
    if [[ ${val} == *#* ]]
    then
      version=$(echo ${val} | cut -d'#' -f 2)
    fi
    plain="$(gcloud beta secrets versions access --secret=${secretName} ${version} ${project})"
    #For multiline management
    export $key="$(echo $plain | sed -e 's/\n//g')"
  fi
done

#run the following command
${1}