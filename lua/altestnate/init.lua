local create_projection = require("altestnate.commands").create_projections_file
local edit_projection = require("altestnate.commands").edit_projections_file
local split_open_alternate = require("altestnate.commands").split_open_alternate
local toggle_alternate = require("altestnate.commands").toggle_alternate

-- TODO
-- cache projections
--
local defaults = {
  keymaps = {
    toggle_alternate = "<leader>at",
    split_open_alternate = "<leader>as",
  },
}

---@class altestnate.Options
---@field keymaps table<string, string>: The keymaps to control slide show

---@type altestnate.Options
local options = {
  keymaps = {},
}

local M = {}

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  -- -- register a CreateProjection command
  -- vim.api.nvim_create_user_command("CreateProjectionsFile", create_projection, {})
  --
  -- -- create a EditProjection command
  -- vim.api.nvim_create_user_command("EditProjection", edit_projection, {})
  --
  -- -- register a ToggleAlternate command
  -- vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})
  --
  -- -- register the split_and_open_alternate command
  -- vim.api.nvim_create_user_command("SplitOpenAlternate", split_open_alternate, {})

  -- -- Keymap to toggle alternate (split vertically and open the alternate file)
  -- vim.keymap.set("n", "<leader>at", toggle_alternate)
  --
  -- -- Keymap to open alternate in a split (split vertically and open the alternate file)
  -- vim.keymap.set("n", "<leader>as", split_open_alternate)
end

local altestnate_keymap = function(mode, key, callback)
  vim.keymap.set(mode, key, callback, {})
end

M.start_altestnate = function()
  -- register a CreateProjection command
  vim.api.nvim_create_user_command("CreateProjectionsFile", create_projection, {})

  -- create a EditProjection command
  vim.api.nvim_create_user_command("EditProjection", edit_projection, {})

  -- register a ToggleAlternate command
  vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})

  -- register the split_and_open_alternate command
  vim.api.nvim_create_user_command("SplitOpenAlternate", split_open_alternate, {})
  -- Keymap to toggle alternate (split vertically and open the alternate file)
  altestnate_keymap("n", options.keymaps.toggle_alternate or defaults.keymaps.toggle_alternate, function()
    toggle_alternate()
  end)

  -- Keymap to open alternate in a split (split vertically and open the alternate file)
  altestnate_keymap("n", options.keymaps.split_open_alternate or defaults.keymaps.split_open_alternate, function()
    split_open_alternate()
  end)
end

vim.api.nvim_create_user_command("AltestnateStart", function()
  M.start_altestnate()
end, {})

return M
