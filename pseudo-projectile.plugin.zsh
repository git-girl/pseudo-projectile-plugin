# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

# if [[ $ZSH_VERSION < 5.8 ]]; then 
# there is something about zparseopts that changed on up to 5.8 zsh
# TODO: check that this is fine
# else
# fi


git_check_read_origin() { 
  git ls-remote &
  pid=$!

  # Set a timeout duration (in seconds)
  timeout_duration=5

  # Wait for the command to complete or timeout
  if timeout $timeout_duration wait $pid 2>/dev/null; then
    echo "Command does not prompt for user input."
    return true 
  else
    echo "Command prompts for user input."
    return false
  fi
}

git_check() { 
  git fetch 
  local res=$(git --no-pager diff @{u} HEAD --name-only)
  return $res

  # fi
  # echo "asdhjklasd "
  # notify-send "PPP: Git Report" "..."
} 

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
        if git_check_read_origin; then 
          ( git_check() | xargs -r notify-send "PPP: G it Report" "" ) & disown;
        else 
          echo "no access to git fetch, remote wasn't checked, check your ssh keys or internet."
        fi
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

