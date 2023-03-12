# Research for new features

## User Stories

### git integration user story

Whenever i open a project i want to have it check git for latest stuff 
I need this to be seamless -> async
I don't want to wait on it -> notification rather then shell stuff

---

### dev tools user story

Whenever i open a project i want dev tools associated with the project i.e a development server 
to be opened 
I'm fine with this being a project makefile or something inputted somewhere in projects dir
  - in projects dir something like .hooks/


## Tooling 

- https://github.com/mafredri/zsh-async
  - seems pretty cool also has a notification feature
  - also seems like bit of hastle 
  - article on working with it https://medium.com/@henrebotha/how-to-write-an-asynchronous-zsh-prompt-b53e81720d32

- Actually do the rust version. 
  - i want to use rust anyways, i think the code base would be much more manageable this way too
  - The issue i had before was that i just couldn't cd because that's outside the confines lol me smort
  - i can just pipe input in however and have async threads do git and dev stuff  

## Plan 
1. Write a proof of concept in rust. 
  - its a program with an async job that returns before the job is finished returning to the shell and input can be piped
    into cd

  ``` bash
  cd $(./target/debug/pseudo-projectile) 
  ```

## Confusion 

- I can run the program with 2 threads where one returns stuff and another runs a git fetch 

- without the sleep the 2nd thread cancels -> once the return is there the thread is dropped 
  and not kept alive

- without the sleep and piping the program into cd means death

- works with sleep but idk if it works if had to run the job longer somewhere before it died

### 2 explanations 
1. it needs some time to trigger the command calls
    -> would be impossible to know how much time is needed and how low i can go because of different system performance 

   - What about the notify call though, thats defietly gone then right.


# Alternative 

use the asysnc stuff of threads 
```
I don't need check for a resolved Future just for a pending one
-> then i know its running and can move on
```
