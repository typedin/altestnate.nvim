if not vim then
  _G.vim = require("vim")
end

-- Ensure runtime path includes plenary and your plugin
vim.cmd("set runtimepath^=./plenary.nvim")
vim.cmd("set runtimepath^=.")

-- Load plenary's test framework
require("plenary.busted")

print("Minimal init loaded for testing")
