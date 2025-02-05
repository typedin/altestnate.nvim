local add_projection = require("altestnate.commands").add_projection
local create_projections_file = require("altestnate.commands").create_projections_file
local edit_projections_file = require("altestnate.commands").edit_projections_file
local split_open_alternate = require("altestnate.commands").split_open_alternate
local toggle_alternate = require("altestnate.commands").toggle_alternate

---@class altestnate.Defaults
---@field keys table<string, string>: The keymaps to control alternate navigation
---@field projections_file string: The name of the file that contains the projections

---@type altestnate.Defaults
local defaults = {
  keys = {
    { "<leader>at", "<cmd>ToggleAlternate<cr>", desc = "Toggle to alternate file" },
    { "<leader>as", "<cmd>SplitOpenAlternate<cr>", desc = "Open alternate file in new vertical split" },
  },
  projections_file = ".protestions.json",
}

---@class altestnate.Options
---@field keys table<string, string>: The keymaps to control alternate navigation
---@field projections_file string: The name of the file that contains the projections

---@type altestnate.Options
local options = {
  keys = {},
  projections_file = "",
}

local M = {}

-- lazy.nvim loads this function
function M.setup(opts)
  opts = opts or {} -- Ensure opts is a table
  opts.keys = opts.keys or {} -- Ensure opts.keys is a table

  options.keys = vim.list_extend(vim.deepcopy(defaults.keys), opts.keys)
  options.projections_file = opts.projections_file or defaults.projections_file
end

---@return string|table<string, string>
function M.get(key)
  if key == nil then
    return options
  end
  return options[key]
end

M.start_altestnate = function()
  -- register a AddProjection command
  vim.api.nvim_create_user_command("AddProjection", add_projection, {})

  -- register a CreateProjection command
  vim.api.nvim_create_user_command("CreateProjectionsFile", create_projections_file, {})

  -- create a EditProjections command
  vim.api.nvim_create_user_command("EditProjectionsFile", edit_projections_file, {})

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
