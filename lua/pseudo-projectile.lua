-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md#bundling-as-extension
return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    openProjects = require("pseudo-projectile").openProjects
  },
}
