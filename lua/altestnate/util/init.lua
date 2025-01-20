local create_projection = require("altestnate.fs").create_projection
local prompt = require("altestnate.prompt").prompt

local M = {}

--- Find the alternate file based on patterns
---@return table
function M.load_projections()
  local projections_file = vim.fn.getcwd() .. "/.projections.json"

  if vim.fn.filereadable(projections_file) == 1 then
    -- TODO
    -- That should be a function that gets projections
    -- If the file exists, read and decode its contents
    local content = vim.fn.readfile(projections_file)
    local decoded = vim.fn.json_decode(table.concat(content, "\n"))
    return decoded
  else
    prompt({ prompt = ".projections.json file NOT found. Create it? (y/n): " }, create_projection)

    return {}
  end
end

return M
