#!/bin/bash
#set -x

snapshots_names() {
  readarray -t snapshots <<< "$(aptly snapshot list -raw | grep -Ev "(trc|ghost|image|pgdg)" | sed -r "s/-[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$//g" | uniq)"
}

published_func() {
  readarray -t published <<< "$(aptly publish list -raw | sed  's/^.\ //')"
}


snapshots_names
published_func


s_names=( "${snapshots[@]/%/-alpha}" "${snapshots[@]/%/-beta}" "${snapshots[@]/%/-sbx}" "${snapshots[@]/%/-prod}" )
published=( "${published[@]}" )


# matches .* ; does not match anything after ?= (positive lookahead)
mapfile -t s_full < <(for i in $(aptly snapshot list -raw | grep -Ev "(trc|ghost|image|pgdg)" | sed -r "s/-[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$//g" | uniq); do aptly snapshot list -raw | grep -P "^$i(?=\-[\d]{4}\-[\d]{2}\-[\d]{2})" | tail -n 1; done)
declare -p s_full 


# $$ is Process ID of bash shell
for i in ${s_names[@]}; do 
  echo "aptly publish snapshot -distribution=${i} ," >> .$$;
done


# Match $s_full; replace date in s_full with nothing; so $s_full is only snapshot_name
for i in ${s_full[@]}; do 
  sed -ir "/${i//-[[:digit:]]*-[[:digit:]]*-[[:digit:]]*/}/s/,/${i}/g" .$$
done


# aptly task run will fail on the first repo that is already published. So we have to be careful to remove any lines that contain existing published snapshots. Better to be safe than sorry

for i in ${published[@]}; do
  sed -i "/$i/d" .$$
done


if [[ -s .$$ ]]; then
  aptly task run -filename=".$$"; rm .$$* 
else
  echo 'Task list is empty.Nothing to do'; rm .$$*
  exit 0 
fi
