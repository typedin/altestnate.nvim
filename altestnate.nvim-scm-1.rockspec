local MODREV, SPECREV = "scm", "-1"
rockspec_format = "3.0"
package = "altestnate.nvim"
version = MODREV .. SPECREV

description = {
  summary = "test navigation",
  detailed = [[
      Neovim plugin for easy navigation between test and source files with configurable key mappings. It integrates with Neovim's built-in user commands and allows you to quickly toggle between alternate files, open them in new splits, and manage projections files. This work is a way to learn a bit about the lua programming language and the Neovim api.
  ]],
  labels = { "neovim", "plugin" },
  homepage = "https://github.com/typedin/altestnate.nvim",
  license = "MIT",
}

dependencies = {
  "lua == 5.1",
  "plenary.nvim",
}

source = {
  url = "git://github.com/typedin/altestnate.nvim",
}
