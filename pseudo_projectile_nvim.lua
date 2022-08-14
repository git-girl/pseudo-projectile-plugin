-- This file provides methods for neovim that can open and add projects
-- to the project symlink directory by pseudo-projectile-plugin for ZSH  

-- Maybe best to just write a custom Telescope picker 
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#introduction

-- it switches the project closing all buffers 
-- if there are are modified buffers you get to choose from another picker which to save 
-- or to save all being offered at the bottom 
-- then it quits the buffers related to

-- i guess using https://github.com/rmagatti/auto-session would be really cool too though 

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")  -- default action open buffer with item => good!
local action_state = require("telescope.actions.state") 

-- TODO: i think this should be local
pseudoProjectile = function(opts) 
    opts = opts or {} 
    projectPath = "/Users/flowergirl/projects" 
    pickers.new(opts, { 
        prompt_title = "Pick project to open",
        finder = finders.new_oneshot_job { 
                'find',
                -- { '-L', '/', '-maxdepth', '1', '-type', 'd', '-print' }  
                opts, 
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry[1],
                        ordinal = entry[1],
                    }
                end

            --{"find", "-L", projectPath, "-maxdepth", "1", "-type", "d", "-print" }, 

            -- results = {"these", "are", "not", "the", "results", "you're", "looking", "for"} 

            -- i want to display the paths in the projects folder and treat the symlinks as directories 
            -- cd_path=$(find -L $PATHTOPROJECTS -maxdepth 1 -type d -print | fzf --no-multi --height 30%)


            -- for now hardcode projectPath  
            -- TODO: how can i get these in there? => what does find do? 
            
            -- finder = finder.new_oneshot_job {
            -- "find", 
            --  string.format("-L ", projectPath ," -maxdepth 1 -type d -print")},
        }, 
        sorter = conf.generic_sorter(opts), 
    }):find()
end 

-- test excec
-- pseudoProjectile() 
