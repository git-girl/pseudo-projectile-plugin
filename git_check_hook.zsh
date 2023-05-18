#!/usr/bin/env zsh

git_check_read_origin_and_fetch() { 
  # returns 124 on timeout to $?
  # returns 127 on command not known to $?
  timeout 3 git fetch 

  retval=$?

  if [[ $retval != 0 ]]; then 
    notify-send "Git Fetch & Diff" "couldn't run git fetch (3sec timeout), check your ssh keys, or internet connection"
  fi

  return $retval
}

run_and_report_git_diff() { 

  git_diff=$(git diff @{u} HEAD --name-only)
  if [[ $git_diff != "" ]]; then
    notify-send "Git Fetch & Diff" "Found these files on origin not present locally: \n $git_diff"
  else 
    notify-send "Git Fetch & Diff" "Clean: no diff to origin isn't ahead of local"
  fi  
}

git_main() { 
  git_check_read_origin_and_fetch

  access=$?

  if [ $access -eq 0 ]; then 
    run_and_report_git_diff >/dev/null & disown
  fi
}

git_check_hook_fn() { 
  if [[ -d './.git' ]]; then
    (git_main 1> /dev/null & disown)
  fi
}

# add with: 
# add-zsh-hook chpwd git_check_hook_fn
