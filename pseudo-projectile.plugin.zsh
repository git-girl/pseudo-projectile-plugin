# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

if [[ $ZSH_VERSION < 5.8 ]]; then 
  # there is something about zparseopts that changed on up to 5.8 zsh
  # TODO: check that this is fine
fi

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
            echo "doing git support"
            # TODO: look if there is a general linux thing for notify-send 
            # i want to send a notification if there is a pull available 
            # but have it run async because i dont want to wait on the fetch 
            git fetch
            # git fetch && git diff HEAD @{u} --name-only         -> without local changes commited
            # git fetch && git diff @{u} --name-only              -> with local changes uncommited 

            # i dont quite care about the diff by git fetch but i care more about that 
            # my version i last pulled is still the one up on the branch

            # Is the HEAD Commit Hash von Fetch origin atm contained in my git log 
            # No? -> ask if i want to update
            # git log | grep $(git fetch get the hash idk) 
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
