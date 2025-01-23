local create_projection = require("altestnate.commands").create_projections_file
local edit_projection = require("altestnate.commands").edit_projections_file
local split_open_alternate = require("altestnate.commands").split_open_alternate
local toggle_alternate = require("altestnate.commands").toggle_alternate

-- TODO
-- cache projections
--

local M = {}

function M.setup()
  -- register a CreateProjection command
  vim.api.nvim_create_user_command("CreateProjectionsFile", create_projection, {})

  -- create a EditProjection command
  vim.api.nvim_create_user_command("EditProjection", edit_projection, {})

  -- register a ToggleAlternate command
  vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})

  -- register the split_and_open_alternate command
  vim.api.nvim_create_user_command("SplitOpenAlternate", split_open_alternate, {})

  -- Keymap to toggle alternate (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>at", toggle_alternate)

  -- Keymap to open alternate in a split (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>as", split_open_alternate)
end

return M
