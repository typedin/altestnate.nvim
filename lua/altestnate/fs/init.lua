local create_file = require("altestnate.fs.create_file")
local load_projections = require("altestnate.fs.load_projections")

local function get_projections_file()
  return require("altestnate").get("projections_file")
end

local M = {}

M.load_projections = load_projections

-- Create the alternate file if the user agrees
function M.create_alternate_file(file_path)
  create_file(file_path)
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

-- function M.create_file(file_path)
--   local dir = vim.fn.fnamemodify(file_path, ":h") -- Get the directory of the new file
--   if vim.fn.mkdir(dir, "p") then -- Create the directory if it doesn't exist
--     vim.notify("Folders existed, not creating them " .. file_path, vim.log.levels.INFO)
--   end
--
--   vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. file_path)
-- end

return M
