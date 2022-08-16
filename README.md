# Pseudo Projectile Plugin for zsh 

This very simple plugin opens project paths with nvim using fzf. 

The command open_project opens a projects path in nvim with calling find piped into fzf in a project directory. 

The project directory contains symlinks to projects, that can be added to it through the add_project command, adding the `pwd`. 

After installing you can of course create aliases for the functions, as typing out open_project is a bother. 

# Why? 

I like projectile in emacs and couldn't find something like it for the terminal. 

I don't like typing out paths, even with recursive FZF search. 

In the end this is practically just FZF customization though :S 

Why not?: If you're looking for project management in nvim i would recommend checking out  [telescope-project](https://github.com/nvim-telescope/telescope-project.nvim) first 

# Getting Started

## Installing

### manual 

1. Clone this repository somewhere on your machine. This guide will assume ~/.zsh/pseudo-projectile.

    `git clone https://github.com/git-girl/pseudo-projectile-plugin ~/.zsh/pseudo-projectile`

2. Add the following to your .zshrc:

    `source ~/.zsh/pseudo-projectile/pseudo-projectile.plugin.zsh` 
    
3. Start a new terminal session.


### oh-my-zsh 

1. Clone this repository into $ZSH_CUSTOM/plugins (by default ~/.oh-my-zsh/custom/plugins)

    `git clone https://github.com/git-girl/pseudo-projectile-plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pseudo-projectile`

2. Add the plugin to the list of plugins for Oh My Zsh to load (inside ~/.zshrc):

    ```
    plugins=( 
        # other plugins...
        pseudo-projectile
    )
    ```

3. Start a new terminal session.

## Setting Up 

### Creating and Setting project path 

1. Create a directory for the symlinks to your projects to go to, f.e.:
```
mkdir ~/projects 
```
2. In your `.zshrc` add your path as `PATHTOPROJECTS`
```
PATHTOPROJECTS='$HOME/projects'
```

### Ideas for Aliasing 
The commands have names that are supposed to be very descriptive.
To have a nicer workflow, I have them aliased. 

f.e. in your ~/.zshrc: 

```
alias po="project_open"
alias pe="project_edit"
alias pa="project_add" 
```
Note: I will refactor the open edit stuff to be the same command using flags.

# State 

This Plugin is currently set up very much for my own workflow. 
Maybe I will spend some more time on it and generalize it. 
