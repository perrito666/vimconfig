vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

require("auto-session").setup({
  suppressed_dirs = { "~", "/tmp", "~/Downloads", "/" },
  cwd_change_handling = true,
  pre_cwd_changed_cmds = {
    "tabdo NERDTreeClose" -- if you're using NERDTree
  },
  post_cwd_changed_cmds = {
    function()
      require("lualine").refresh()
    end
  },
})

