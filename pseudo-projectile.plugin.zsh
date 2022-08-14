# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

PATHTOPROJECTS="$HOME/projects"

# open project symlink folder with FZF and start nvim
open_project() { 
    cd $(find -L $PATHTOPROJECTS -maxdepth 1 -type d -print | fzf --no-multi --height 30%)
    nvim .
} 

# add project (PWD to project symlink folder) 
add_project() { 
    ln -s $PWD $PATHTOPROJECTS
    echo "added $PWD to projects"
} 

