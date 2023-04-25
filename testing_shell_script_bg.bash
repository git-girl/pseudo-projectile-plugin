#!/usr/bin/env bash 

# run in bg -> 
# vim &

# run in full detach -> 
# cmd="google-chrome";
# "${cmd}" &>/dev/null & disown;

# WARNING: this only compares and i really want this name only and 
# if im missng files and not if there is a diff to origin

# res=$(git fetch origin && git diff HEAD)

# NOTE: This works like i want it to
git fetch origin && git diff HEAD &>/dev/null | notify-send "PPP Git Report" "Finished the thing" & disown;

# if [ -n "$res" ]; then
#     notify-send "PPP: Git Report" "Found Diff to origin"
# fi
