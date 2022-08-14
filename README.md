# Pseudo Projectile Plugin for zsh 

This Plugin opens project paths with nvim using fzf. 

The function open_project opens a projects path in nvim with calling find piped into fzf in a project directory. 

The project directory contains symlinks to projects, that can be added to it through the add_project function, adding the `pwd`. 

# Why? 

I like projectile in emacs and couldn't find something like it for the terminal. 
I don't like typing out paths, even with recursive FZF search. 

# State 

This Plugin is currently set up very much for my own workflow. 
Maybe I will spend some more time on it and generalize it. 

# TODOs 

- [ ] add customization options ( calling neovim, some other editor or none ) 
- [ ] add customization function for paths
