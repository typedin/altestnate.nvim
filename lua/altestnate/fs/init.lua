local prompt = require("altestnate.prompt").prompt

local function get_projections_file()
  return require("altestnate").get("projections_file")
end

local M = {}

-- Create the alternate file if the user agrees
function M.create_alternate_file(file_path)
  local callback = function()
    local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
    vim.fn.mkdir(dir, "p") -- Create the directory if it doesn't exist
    vim.fn.writefile({}, file_path) -- Create an empty file
    vim.cmd("edit " .. file_path) -- Open the file
    vim.notify("Created and opened: ", vim.log.levels.INFO)
  end

  prompt({ prompt = "Alternate file not found. Create it? (y/n): " }, callback)
end

function M.edit_projection()
  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. get_projections_file())
end

-- TODO
-- ask the user for their project structure
function M.create_projection()
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
  vim.fn.writefile(vim.fn.split(default_template, "\n"), get_projections_file())
  -- ask for source folder
  -- ask for extension
  -- ask for test folder
  -- from that create the test alternate
end

function M.create_file(file_path)
  local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
  if vim.fn.mkdir(dir, "p") then -- Create the directory if it doesn't exist
    vim.notify("Folders existed, not creating them" .. file_path, vim.log.levels.INFO)
  end

  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. file_path)
end

return M
