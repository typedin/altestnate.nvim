--- Load the projections from the projections file
---@param projections_file_path string
---@return table
local function load_projections(projections_file_path)
  local projections = {}

  if vim.fn.filereadable(projections_file_path) == 1 then
    local content = vim.fn.readfile(projections_file_path)
    projections = vim.fn.json_decode(table.concat(content, "\n"))
  end

  return projections
end

return load_projections
