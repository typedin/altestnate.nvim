--[[
  @see help expand() :h fnamemodify
  Modifiers:
    :p		expand to full path
    :h		head (last path component removed)
    :t		tail (last path component only)
    :r		root (one extension removed)
    :e		extension only
--]]
local M = function(args)
  if args == nil then
    return {}
  end
  -- TODO
  -- sanatize path eg: remove /

  -- :h		head (last path component removed)
  local source_path = vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":h")
  -- :t		tail (last path component only)
  -- :r		root (one extension removed)
  local filename = vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":t:r")

  local file_extension = vim.fn.fnamemodify(vim.fn.expand(args.entry_key), ":e")
  local source_entry = args.entry_key:gsub(filename, "*")
  local test_entry = args.test_folder .. "/*" .. args.test_suffix .. "." .. file_extension

  return {
    [source_entry] = {
      alternate = args.test_folder .. "/{}" .. args.test_suffix .. "." .. file_extension,
      type = "source",
    },
    [test_entry] = {
      alternate = source_path .. "/{}" .. "." .. file_extension,
      type = "test",
    },
  }
end

return M
