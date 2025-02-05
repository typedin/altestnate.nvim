local create_projections_entry = require("altestnate.commands.create_projections_entry")

---@param input string space separated values
---@return table
local function M(input)
  local args = {
    "entry_key",
    "test_folder",
    "test_suffix",
  }

  local mapped_args = {}

  local index = 1
  for word in string.gmatch(input, "%S+") do
    local key = args[index]
    if key then
      mapped_args[key] = word
    end
    index = index + 1
  end
  return create_projections_entry(mapped_args)
end

return M
