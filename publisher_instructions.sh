#!/bin/bash
#set -x
# :: Master
# 1. Create tasklist in /var/aptly/public for all of your subscribers to consume.
# 2. Provide production aptly subcribers a list of commands to run to create mirrors they do not have.
#       a) filter the commands
#       b) filter sbx/prod
#       c) append to tasklist

URL='http://YOUR_URL_HERE'
TASKLIST='/var/aptly/public/tasklist'

published_func() {
# Filter out published snapshots that do not have sbx/prod appended. Thats just something I have to do for my own aptly environment.
  readarray -t published <<< "$(aptly publish list -raw | sed 's/^.\ //' | grep -E "\-prod|\-sbx")"
}
published_func

#SUBSCRIBER COMMANDS

if [[ -f ${TASKLIST} ]]; then
  rm ${TASKLIST};
fi

for i in ${published[@]}; do
  echo "mirror create ${i} ${URL} ${i} main" >> ${TASKLIST}
done
