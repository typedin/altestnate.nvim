-- local split_open_alternate = require("altestnate.commands").split_open_alternate
local toggle_alternate = require("altestnate.commands").toggle_alternate

-- WARNING
-- This code has been generated with LLM and I'm not proud of it
-- This code helps me to navigate easily between a source file and its tests
--
local M = {}
local projections = require("altestnate.util").load_projections()

function M.setup()
  -- register the find_alternate command
  -- vim.api.nvim_create_user_command("FindAlternate", function()
  --   require("altestnate.util").find_alternate(projections)
  -- end, { desc = "Find Alternate file" })
  -- register the toggle_alternate command
  -- vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})
  -- register the split_and_open_alternate command
  -- vim.api.nvim_create_user_command("SplitOpenAlternate", split_open_alternate, {})
  -- Keymap to toggle alternate (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>at", function()
    toggle_alternate(projections)
  end)
  -- Keymap to open alternate in a split (split vertically and open the alternate file)
  -- vim.keymap.set("n", "<leader>as", split_open_alternate, { noremap = true, silent = true })
  --
  -- TODO
  -- create a CreateProjection commad

  -- TODO
  -- create a EditProjection command
end

return M
