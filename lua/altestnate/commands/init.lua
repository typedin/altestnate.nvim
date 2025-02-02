local create_file = require("altestnate.fs").create_file
local create_projection = require("altestnate.fs").create_projection
local edit_projection = require("altestnate.fs").edit_projection
local find_alternate = require("altestnate.commands.find_alternate").find_alternate
local load_projections = require("altestnate.util").load_projections
local prompt = require("altestnate.prompt").prompt

---@class AltestnateCommand
local M = {}

local function get_projections_file()
  return require("altestnate").get("projections_file")
end

M.create_projections_file = function()
  -- TODO
  -- control that the file was createdd
  prompt({ prompt = "Create a .projections file? (y/n): " }, create_projection)
  prompt({ prompt = "Edit the .projections file? (y/n): " }, function()
    vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. get_projections_file())
  end)
end

M.edit_projections_file = function()
  prompt({ prompt = "Edit the .projections file? (y/n): " }, edit_projection)
end

---Private function
---TODO
---read :h expand
---
---@return string
local function get_alternate()
  local projections = load_projections(get_projections_file())
  return find_alternate(projections, vim.fn.expand("%:p"))
end

-- Toggle between source and test files
function M.toggle_alternate()
  local alternate_path = get_alternate()
  if alternate_path then
    if vim.fn.filereadable(alternate_path) == 1 then
      vim.cmd("edit " .. alternate_path)
    else
      create_file(alternate_path)
    end
  else
    vim.notify("No alternate file found!", vim.log.levels.WARN)
  end
end

-- Function to split and open the alternate file in a vertical split
function M.split_open_alternate()
  local alternate_path = get_alternate()
  if alternate_path then
    -- Perform a vertical split and open the alternate file
    -- if file exists open it
    -- else edit a new buffer
    if vim.fn.filereadable(alternate_path) == 1 then
      vim.cmd("vsplit " .. alternate_path)
    else
      create_file(alternate_path)
    end
  else
    vim.notify("No alternate file found!", vim.log.levels.WARN)
  end
end

return M
