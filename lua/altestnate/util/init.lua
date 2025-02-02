local create_projection = require("altestnate.fs").create_projection
local prompt = require("altestnate.prompt").prompt

local M = {}

--- Find the alternate file based on patterns
---@param projections_file_path string
---@return table
function M.load_projections(projections_file_path)
  local projections = {}

  if vim.fn.filereadable(projections_file_path) == 1 then
    -- TODO
    -- That should be a function that gets projections
    -- If the file exists, read and decode its contents
    local content = vim.fn.readfile(projections_file_path)
    projections = vim.fn.json_decode(table.concat(content, "\n"))
  else
    prompt({ prompt = projections_file_path .. " file NOT found. Create it? (y/n): " }, create_projection)
  end

  return projections
end

return M
