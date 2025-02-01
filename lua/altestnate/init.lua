local create_projection = require("altestnate.commands").create_projections_file
local edit_projection = require("altestnate.commands").edit_projections_file
local split_open_alternate = require("altestnate.commands").split_open_alternate
local toggle_alternate = require("altestnate.commands").toggle_alternate

-- TODO
-- cache projections
--
local defaults = {
  keys = {
    { "<leader>at", "<cmd>ToggleAlternate<cr>", desc = "Toggle to alternate file" },
    { "<leader>as", "<cmd>SplitOpenAlternate<cr>", desc = "Open alternate file in new vertical split" },
    { "<leader>ae", "<cmd>EditProjectionFile<cr>", desc = "Edit the projection file" },
    { "<leader>ac", "<cmd>CreateProjectionsFile<cr>", desc = "Create a projection file" },
  },
}

---@class altestnate.Options
---@field keys table<string, string>: The keymaps to control alternate navigation

---@type altestnate.Options
local options = {
  keys = {},
}

local M = {}

-- lazy.nvim loads this function
function M.setup(opts)
  opts = opts or {} -- Ensure opts is a table
  opts.keys = opts.keys or {} -- Ensure opts.keys is a table

  options.keys = vim.list_extend(vim.deepcopy(defaults.keys), opts.keys)
end

M.start_altestnate = function()
  -- register a CreateProjection command
  vim.api.nvim_create_user_command("CreateProjectionsFile", create_projection, {})

  -- create a EditProjection command
  vim.api.nvim_create_user_command("EditProjectionFile", edit_projection, {})

  -- register a ToggleAlternate command
  vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})

  -- register the split_and_open_alternate command
  vim.api.nvim_create_user_command("SplitOpenAlternate", split_open_alternate, {})

  -- apply the keymaps
  for _, keymap in ipairs(options.keys) do
    vim.keymap.set("n", keymap[1], keymap[2], { desc = keymap.desc or "" })
  end
end

return M
