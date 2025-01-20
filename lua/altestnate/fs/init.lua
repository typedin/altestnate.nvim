local prompt = require("altestnate.prompt").prompt

local projections_file = vim.fn.getcwd() .. "/.projections.json"

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

local M = {}

-- Create the alternate file if the user agrees
function M.create_alternate_file(file_path)
  local callback = function()
    local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
    vim.fn.mkdir(dir, "p") -- Create the directory if it doesn't exist
    vim.fn.writefile({}, file_path) -- Create an empty file
    vim.cmd("edit " .. file_path) -- Open the file
    print("Created and opened: " .. file_path)
  end

  prompt({ prompt = "Alternate file not found. Create it? (y/n): " }, callback)
end

function M.edit_projection()
  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. ".projections.json")
end

function M.create_projection()
  vim.fn.writefile(vim.fn.split(default_template, "\n"), projections_file)
end

function M.create_file(file_path)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
  if vim.fn.mkdir(dir, "p") then -- Create the directory if it doesn't exist
    vim.notify("Folders existed, not creating them" .. file_path, vim.log.levels.INFO)
  end

  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. file_path)
end

--- Find the alternate file based on patterns
---@return table
function M.load_projections()
  local projections = {}

  if vim.fn.filereadable(projections_file) == 1 then
    -- TODO
    -- That should be a function that gets projections
    -- If the file exists, read and decode its contents
    local content = vim.fn.readfile(projections_file)
    projections = vim.fn.json_decode(table.concat(content, "\n"))
  else
    prompt({ prompt = ".projections.json file NOT found. Create it? (y/n): " }, M.create_projection)
  end

  return projections
end

return M
