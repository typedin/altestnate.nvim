---@class UserInputEntry
---@field value string
---@field prompt string
---@field error string

---@type table<string, UserInputEntry>
local user_input = {
  entry_key = {
    value = "",
    prompt = "Source file for a projection (ex: src/init.lua) :",
    error = "No input provided for source file.",
  },
  test_folder = {
    value = "",
    prompt = "Test folder for this source file (ex: tests): ",
    error = "No input provided for test folder.",
  },
  test_suffix = {
    value = "",
    prompt = "Suffix for the source file (ex: _spec, or spec_): ",
    error = "No input provided for test suffix/prefix.",
  },
}

return user_input
