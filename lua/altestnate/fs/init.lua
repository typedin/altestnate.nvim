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
  print("loaded")
  local callback = function()
    local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
    vim.fn.mkdir(dir, "p") -- Create the directory if it doesn't exist
    vim.fn.writefile({}, file_path) -- Create an empty file
    vim.cmd("edit " .. file_path) -- Open the file
    print("Created and opened: " .. file_path)
  end

  prompt({ prompt = "Alternate file not found. Create it? (y/n): " }, callback)
end

function M.create_projection()
  vim.fn.writefile(vim.fn.split(default_template, "\n"), projections_file)
end

return M
