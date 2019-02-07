#!/bin/bash
set -x
# :: Subscriber
# 1. Download tasklist
# 2. filter out mirrors you already have
# 3. aptly task run file="tasklist"


mirror_func() {
  readarray -t mirrors <<< "$(aptly mirror list -raw)"
}

mirror_func
#1
URL='http://YOUR_URL_HERE'
MYIP=$(ip addr show eth0 | grep -E "inet[^6]" | head -n 1 | cut -b10- | cut -d "/" -f1 | cut -d "." -f2)
wget $URL/tasklist -O .$$

# 2

# Special if-else statement to filter sandbox environment
for i in ${mirrors[@]}; do
  if [[ ${MYIP} =~ 100|102 ]]; then
    sed -i "/${i}/d" .$$
    else
    sed -i "/${i}/d" .$$
    sed -ir "/-sbx/d" .$$
  fi
done

# 3
if [[ -s .$$ ]]; then
  cat .$$
  aptly task run -filename=.$$; rm .$$*
else
  echo 'Task list is empty.Nothing to do'; rm .$$*
  exit 0
fi
