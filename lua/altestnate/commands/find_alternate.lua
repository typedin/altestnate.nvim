local M = {}

---@param projections table<string, table>>
---@param file_path string
---@return string|nil
M.find_alternate = function(projections, file_path)
  local current_file = file_path

  local result = nil
  -- since I cannot regex I split the pattern in two
  -- loop over all projections for source files
  for pattern, config in pairs(projections) do
    local lua_pattern = pattern:gsub("%*", "(.+)") -- Convert '*' to non-greedy capture
    local match = current_file:match(lua_pattern)
    if match then
      result = config.alternate:gsub("{basename}", match):gsub("{}", match)
    end
  end
  -- loop over all projections for test files
  for pattern, config in pairs(projections) do
    local lua_pattern = pattern:gsub("%*", "([^/]+)") --:gsub("%.", "%%.")
    local match = current_file:match(lua_pattern)
    if match then
      result = config.alternate:gsub("{basename}", match):gsub("{}", match)
    end
  end
  return result
end

return M
