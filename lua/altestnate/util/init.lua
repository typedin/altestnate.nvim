local M = {}

-- Default template for .projections.json
local default_template = [[
  {
    "src/*.ts": {
      "alternate": "src/__tests__/{basename}.test.ts",
      "type": "source"
    },
      "src/__tests__/*.test.ts": {
      "alternate": "src/{basename}.ts",
      "type": "test"
    }
  }
]]
-- Create the alternate file if the user agrees
function M.create_file(file_path)
  local confirm = vim.fn.input("File does not exist. Create it? (y/n): ")
  if confirm:lower() == "y" then
    local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
    vim.fn.mkdir(dir, "p") -- Create the directory if it doesn't exist
    vim.fn.writefile({}, file_path) -- Create an empty file
    vim.cmd("edit " .. file_path) -- Open the file
    print("Created and opened: " .. file_path)
  else
    print("Aborted.")
  end
end

-- TODO
-- for further references
--  local project_root = vim.fn.getcwd() -- Get the project root directory

-- Find the alternate file based on patterns
function M.find_alternate(projections)
  local current_file = vim.fn.expand("%:p") -- Get the full path of the current file
  for pattern, config in pairs(projections) do
    -- Convert the JSON pattern to a Lua regex
    local lua_pattern = pattern:gsub("%*", "(.*)")
    local match = { current_file:match(lua_pattern) }
    if #match > 0 then
      -- Replace {basename} with the captured part
      return config.alternate:gsub("{basename}", match[1])
    end
  end
  return nil
end

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
    -- If the file doesn't exist, prompt to create it
    -- local confirm = vim.fn.input("No .projections.json file found. Create it? (y/n): ")
    vim.ui.input({
      prompt = "No .projections.json file found. Create it? (Y/n): ",
      default = "y",
    }, function(input)
      if input:lower() == "y" then
        -- Create the .projections.json file with the default template
        vim.fn.writefile(vim.fn.split(default_template, "\n"), projections_file)
        print(".projections.json has been created with a basic template!")
      else
        print("Aborted.")
      end
    end)
    if confirm:lower() == "y" then
      -- Create the .projections.json file with the default template
      vim.fn.writefile(vim.fn.split(default_template, "\n"), projections_file)
      print(".projections.json has been created with a basic template!")
    else
      print("Aborted.")
    end
    return {}
  end
end

return M
