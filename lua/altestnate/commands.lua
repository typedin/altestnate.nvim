local create_file = require("altestnate.utils").create_file
local find_alternate = require("altestnate.utils").find_alternate
local load_projections = require("altestnate.utils").load_projections

---@class AltestnateCommand
local M = {}

---@type table<string, fun()>
M.commands = {}
local projections = load_projections()

-- Toggle between source and test files
function M.toggle_alternate()
  local alternate = find_alternate(projections)
  if alternate then
    if vim.fn.filereadable(alternate) == 1 then
      vim.cmd("edit " .. alternate)
    else
      create_file(alternate)
    end
  else
    print("No alternate file found!")
  end
end

-- Function to split and open the alternate file in a vertical split
function M.split_and_open_alternate()
  local alternate = find_alternate()
  if alternate then
    -- Perform a vertical split and open the alternate file
    vim.cmd("vsplit " .. alternate)
  else
    print("No alternate file found!")
  end
end

return M
