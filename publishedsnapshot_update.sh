#!/bin/bash

DATE=`date +%Y-%m-%d`

# update every mirror in a loop, write stdout to tmp file

for m in `aptly mirror list -raw`; do
    aptly mirror update ${m} | tee /tmp/.$$

# read tmp file - if content was actually downloaded - create a snapshot & switch published snapshot
# else do nothing

UPDATES=$(cat /tmp/.$$ | grep -i 'Download queue:' | awk '{ print $3 }')
if [[ $UPDATES -ge 1 ]]; then
    aptly task run snapshot create ${m}-${DATE} from mirror ${m}, publish switch ${m} ${m}-${DATE}
fi

rm /tmp/.$$
done
