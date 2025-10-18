require("nvim-tree").setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    icons = {
      show = {
        folder = true,
        file = true,
        folder_arrow = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  git = {
    enable = true,
  },
})
