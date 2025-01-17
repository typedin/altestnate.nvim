local find_alternate = require("altestnate.utils").find_alternate
local split_and_open_alternate = require("altestnate.utils").split_and_open_alternate
local toggle_alternate = require("altestnate.utils").toggle_alternate
--
-- This code has been generated with LLM and I'm not proud of it
-- This code helps me to navigate easily between a source file and its tests
--

-- Function to split and open the alternate file in a vertical split
-- local function split_and_open_alternate()
--   local alternate = find_alternate()
--   if alternate then
--     -- Perform a vertical split and open the alternate file
--     vim.cmd("vsplit " .. alternate)
--   else
--     print("No alternate file found!")
--   end
-- end

local M = {}

function M.setup()
  print("Hello from altestnate")
  -- register the find_alternate command
  vim.api.nvim_create_user_command("FindAlternate", find_alternate, {})
  -- register the toggle_alternate command
  vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})
  -- Keymap to toggle alternate (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>at", toggle_alternate)
  -- Keymap to open alternate in a split (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>as", split_and_open_alternate, { noremap = true, silent = true })
end

return M
