# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

project_open() { 

    start_dir=$PWD 

    #set the path to cd into and perform checks
    cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -print | fzf --no-multi --height 30%)

    # only open if there is some cd path selected 
    if [[ $cd_path != "" ]] then
        # TODO: if $cd_path.is_a(Directory) elif cd_path.is_a(File) -> go to directory in file path before it
        cd $cd_path
    fi
} 

# weird naming but better as gp will be aliased alot 
project_edit() {  

    start_dir=$PWD 

    #set the path to cd into and perform checks
    cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -print | fzf --no-multi --height 30%)

    # only open if there is some cd path selected 
    if [[ $cd_path != "" ]] then
        cd $cd_path
        nvim . 
    fi
} 
# add project (PWD to project symlink folder) 
project_add() { 
    ln -s $PWD $PATHTOPROJECTS
    echo "added $PWD to projects"
} 
