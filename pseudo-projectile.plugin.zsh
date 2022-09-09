# Pseudo-Projectile Plugin for zsh
# Written by Git Girl (git-girl) 
# github.com/git-girl/pseudo-projectile-plugin

# open project symlink folder with FZF and start nvim

# TODO: Showing Path should be an Option OR RATHER HOW MUCH OF PATH

project_open() { 

    local start_dir=$PWD 
    # default size 10 Percent
    local size=10

    while getopts "e:s:" opt; do 
        case "${opt}" in
            e)
                local editor=${OPTARG} # should return stuff like nvim, vim, code
                ;;
            s) 
                local size=${OPTARG}
                echo $size
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
                echo "must supply an argumen" 
                echo "TODO: this needs to abort fzf" 
                ;;
        esac
    done

    #set the path to cd into and perform checks
    local cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -print | fzf --no-multi --height $size)

    # only open if there is some cd path selected 
    if [[ $cd_path != "" ]] then
        # TODO: if $cd_path.is_a(Directory) elif cd_path.is_a(File) -> go to directory in file path before it
        cd $cd_path
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

# TODO: there should be some way to call an alias like po and pass the typed stuff before entering 
# as a search into fzf if there is only one entry returned open it
#
