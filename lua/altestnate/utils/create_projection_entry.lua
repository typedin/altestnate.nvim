---@param a_path any path passed in by the user
---@return string sanatized path without leading and trailing slashes
local function sanatize_path(a_path)
  local result = vim.fn.substitute(a_path, "^/", "", "") -- remove leading slash
  result = vim.fn.substitute(result, "/$", "", "") -- remove trailing slash

  return result
end

local has_prefix = function(args)
  return string.sub(args.test_suffix, #args.test_suffix, #args.test_suffix) == "_"
    or string.sub(args.test_suffix, #args.test_suffix, #args.test_suffix) == "."
end

---@class UserInput
---@field entry_key string The source file path.
---@field test_folder string The test folder path.
---@field test_suffix string The suffix for the test file.

---@param args UserInput|nil The user input containing file paths and test suffix.
---@return table<string, { alternate: string, type: "source" | "test" }>
local function M(args)
  if args == nil then
    return {}
  end

  -- @read :help expand() and @read :help fnamemodify
  local source_path = sanatize_path(vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":h"))
  local filename = vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":t:r")
  local file_extension = vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":e")

  local source_entry = sanatize_path(args.entry_key:gsub(filename, "*"))
  local test_folder = sanatize_path(args.test_folder)

  local test_entry = ""
  local source_entry_alternate = ""
  local test_entry_alternate = ""

  if has_prefix(args) then
    source_entry_alternate = test_folder .. "/" .. args.test_suffix .. "{}." .. file_extension
    test_entry = test_folder .. "/" .. args.test_suffix .. "*." .. file_extension
    test_entry_alternate = source_path .. "/{}" .. "." .. file_extension
  else
    source_entry_alternate = test_folder .. "/{}" .. args.test_suffix .. "." .. file_extension
    test_entry = test_folder .. "/*" .. args.test_suffix .. "." .. file_extension
    test_entry_alternate = source_path .. "/{}" .. "." .. file_extension
  end

  return {
    [source_entry] = {
      alternate = source_entry_alternate,
      type = "source",
    },
    [test_entry] = {
      alternate = test_entry_alternate,
      type = "test",
    },
  }
end

return M
