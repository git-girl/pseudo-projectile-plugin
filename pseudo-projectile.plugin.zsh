# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

PATHTOPROJECTS="$HOME/projects"

# open project symlink folder with FZF and start nvim
open_project() { 

    start_dir=$PWD 

    #set the path to cd into and perform checks
    cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -type d -print | fzf --no-multi --height 30%)

    # only open if there is some cd path selected 
    if [[ $cd_path != "" ]] then
        nvim . 
    fi
} 

# add project (PWD to project symlink folder) 
add_project() { 
    ln -s $PWD $PATHTOPROJECTS
    echo "added $PWD to projects"
} 

