local create_projection = require("altestnate.fs").create_projection
local load_projections = require("altestnate.util").load_projections
local create_file = require("altestnate.util").create_file
local prompt = require("altestnate.prompt").prompt

---@class AltestnateCommand
local M = {}

M.create_projections_file = function()
  -- TODO
  -- control that the file was createdd
  prompt({ prompt = "Create a .projections file? (y/n): " }, create_projection)
  prompt({ prompt = "Edit the .projections file? (y/n): " }, function()
    vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. ".projections.json")
  end)
end

M.find_alternate = function(projections)
  local current_file = vim.fn.expand("%:p") -- Full path of the current file

  -- Iterate through all projection patterns
  for pattern, config in pairs(projections) do
    -- Convert the glob-style pattern to a Lua regex
    local lua_pattern = pattern:gsub("%*", "(.-)") -- Convert '*' to non-greedy capture
    -- Test the matching part
    local match = current_file:match(lua_pattern)
    -- If the match is successful, substitute {basename}
    if match then
      return config.alternate:gsub("{basename}", match):gsub("{}", match)
    end
  end
  return nil -- No match found
end

-- Toggle between source and test files
function M.toggle_alternate()
  local projections = load_projections()
  local alternate = M.find_alternate(projections)
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
function M.split_open_alternate()
  local alternate = M.find_alternate()
  if alternate then
    -- Perform a vertical split and open the alternate file
    vim.cmd("vsplit " .. alternate)
  else
    print("No alternate file found!")
  end
end

return M
