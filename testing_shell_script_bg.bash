#!/usr/bin/env bash 

# run in bg -> 
# vim &

# run in full detach -> 
# cmd="google-chrome";
# "${cmd}" &>/dev/null & disown;
# TODO: Do a check if the proper ssh key is added to key agent
# but i think if you take out internet then it just fails quietly and nice :) 

# res=$(git fetch origin && git diff HEAD)
if [ $nogit != true ]; then
  res=$(git fetch && git diff @{u} HEAD --name-only) & disown;
fi

if [ -n "$res" ]; then
  notify-send "PPP: Git Report" "Found Diff to origin"
fi
