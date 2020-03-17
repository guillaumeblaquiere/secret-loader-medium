#!/bin/sh

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
               echo $val
               secret=$(echo ${val} | cut -d'#' -f 1)
               version=$(echo ${val} | cut -d'#' -f 2)
               echo $secret
               if [ -z ${version} ]
               then
                       version="latest"
               fi
               echo $version
               export $key=$(gcloud beta secrets versions access --secret=${secret} ${version})
       fi
done

#run the following command
${1}