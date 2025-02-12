---@param projections table<string, table>>
---@param file_path string
---@param no_alternate_flag string|nil so the user can use their flag for files with no alternate files
---@return string|nil
local find_alternate = function(projections, file_path, no_alternate_flag)
  no_alternate_flag = no_alternate_flag or ""
  local current_file = file_path

  local result = nil
  -- since I cannot regex I split the pattern in two
  -- loop over all projections for source files
  for pattern, config in pairs(projections) do
    local lua_pattern = pattern:gsub("%*", "(.+)") -- Convert '*' to non-greedy capture
    local match = current_file:match(lua_pattern)
    if match then
      if config.alternate == no_alternate_flag then -- handle case where no projections are wanted
        return nil
      end
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

return find_alternate
