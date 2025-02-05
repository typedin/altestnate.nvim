--- Create a new file at the given path
--- @param file_path string
--- @return number -1|0 -1 if the file already exists or the operation fails, 0 otherwise
local function create_file(file_path)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
  -- p will silently exit if the directory already exists
  vim.fn.mkdir(dir, "p") -- Create the directory if it doesn't exist
  if vim.fn.filereadable(file_path) == 1 then
    return -1
  end
  return vim.fn.writefile({}, file_path)
end

return create_file
