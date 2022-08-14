# Pseudo Projectile Plugin for zsh 

This Plugin opens project paths with nvim using fzf. 

The function open_project opens a projects path in nvim with calling find piped into fzf in a project directory. 

The project directory contains symlinks to projects, that can be added to it through the add_project function, adding the `pwd`. 

# Why? 

I like projectile in emacs and couldn't find something like it for the terminal. 
I don't like typing out paths, even with recursive FZF search. 


# Getting Started

## manual 

Clone this repository somewhere on your machine. This guide will assume ~/.zsh/zsh-autosuggestions.

git clone https://github.com/git-girl/pseudo-projectile-plugin ~/.zsh/pseudo-projectile

2. Add the following to your .zshrc:

source ~/.zsh/pseudo-projectile/pseudo-projectile.plugin.zsh 

3. Start a new terminal session.


## oh-my-zsh 

1. Clone this repository into $ZSH_CUSTOM/plugins (by default ~/.oh-my-zsh/custom/plugins)
`git clone https://github.com/git-girl/pseudo-projectile-plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pseudo-projectile`

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):

    plugins=( 
        # other plugins...
        pseudo-projectile
    )

3. Start a new terminal session.


# State 

This Plugin is currently set up very much for my own workflow. 
Maybe I will spend some more time on it and generalize it. 

# TODOs 

- [ ] add customization options ( calling neovim, some other editor or none ) 
- [ ] add customization function for paths
