-- This file provides methods for neovim that can open and add projects
-- to the project symlink directory by pseudo-projectile-plugin for ZSH  
-- it switches the project closing all buffers 
-- if there are are modified buffers you get to choose from another picker which to save 
-- or to save all being offered at the bottom 
-- then it quits the buffers related to

-- i guess using https://github.com/rmagatti/auto-session would be really cool too though 

-- Maybe best to just write a custom Telescope picker 
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#introduction

local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error "This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)"
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")  -- default action open buffer with item => good!
local action_state = require("telescope.actions.state") 

-- TODO: i think this should be local
-- Usage: call pseudoProjectile('/absolute/path/to/projects') 

openProjects = function(path, opts) 
    opts = opts or {} 

    pickers.new(opts, { 
        prompt_title = "Pick project to open",
        finder = finders.new_oneshot_job( 
        { 
            'find', '-L', path, '-maxdepth', '1'
        }   
        ), 
        sorter = conf.generic_sorter(opts), 
    }):find()
end 

-- test excec
-- pseudoProjectile() 
