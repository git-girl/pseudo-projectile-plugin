# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

# if [[ $ZSH_VERSION < 5.8 ]]; then 
# there is something about zparseopts that changed on up to 5.8 zsh
# TODO: check that this is fine
# else
# fi

project_open() { 

  local start_dir=$PWD 
  # default size 10 Percent
  local size=10

    # TODO: add the --nogit flag after having done the rewrite to zparseopts
    while getopts "e:s:h" opt; do 
      case "${opt}" in
        e)
          local editor=${OPTARG} # should return stuff like nvim, vim, code
          shift 2
          ;;
        s) 
          local size=${OPTARG}
          shift 2
          ;;
        h) 
          echo "this should return a usage out"
          return
          ;;
        :) 
          echo "this should return a usage out"
          echo "TODO: this needs to abort fzf" 
          ;;
        ?) 
          echo "must supply an argument" 
          echo "TODO: this needs to abort fzf" 
          ;;
      esac
    done

    #set the path to cd into and perform checks ( and do color support)
    if [[ $1 ]]; then
      local cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -print | fzf --no-multi --height $size -1 -q $1)
    else 
      local cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -print | fzf --no-multi --height $size)
    fi

    # only open if there is some cd path selected 
    if [[ $cd_path != "" ]]; then
      cd $cd_path

      if [[ !$nogit && -d './.git' ]]; then
        # no ssh access fails quietly :) 
        # a_function | [ xargs -r ] another_function

        # BUG: If no password this results into uncallable git threads
        # NOTE: Can you just make this a function and then disown that?

        git_main & disown
      fi
      if (( ${+editor} )); then 
        $editor . 
      fi
    fi
  } 

# add project (PWD to project symlink folder) 
project_add() { 
  ln -s $PWD $PATHTOPROJECTS
  echo "added $PWD to projects"
} 

git_check_read_origin_and_fetch() { 
  # returns 124 on timeout to $?
  # returns 127 on command not known to $?
  timeout 3 git fetch 

  retval=$?

  if [[ $retval != 0 ]]; then 
    notify-send "PPP Git Report" "couldn't run git fetch (3sec timeout), check your ssh keys, or internet connection"
  fi

  return $retval
}

run_and_report_git_diff() { 

  git_diff=$(git diff @{u} HEAD --name-only)
  if [[ $git_diff != "" ]]; then
    notify-send "PPP Git Report" "Found these files on origin not present locally: \n $git_diff"
  else 
    notify-send "PPP Git Report" "Clean: no diff to origin isn't ahead of local"
  fi  
}

git_main() { 
  git_check_read_origin_and_fetch

  access=$?

  echo "access exit code is: $access"

  if [ $access -eq 0 ]; then 
    echo "started git check"
    run_and_report_git_diff & disown
  fi
}
