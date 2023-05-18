## Current Design Questions

- jumping itself is a solved issue. There is really nothing to be done there i feel like 
  - different projects recognize your projects after a while or you get the same functionality that ppp has atm

- the cool thing that i didn't see yet is this git thing. 
  - the git thing is better suited to be a hook though as its something you want to always run anyways.

- the idea regarding the dev stuff is a bit more complicated and maybe having something like a tmux session for a 
  project is the easier way to go about things. 
  - Its really hard to make good choices when it comes to auto shutting down post leaving a dir and stuff like this.
  - also i do want things to run in the foreground be assigned to the correct window layout on the correct workspaces 
    - thats easier done with i3 and maybe tmux


ZSH has something called prompts and bash has something like PROMPT_COMMNAD 
you can set that var to something and it runs after every command this is what i want

there is the zsh-add-hook to add hooks 
there even is a thing called `chpwd` as a hook event

https://github.com/zsh-users/zsh/blob/master/Functions/Misc/add-zsh-hook

