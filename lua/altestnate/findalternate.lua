local M = {}

local function find_alternate(projections)
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

M.find_alternate = find_alternate
return M
