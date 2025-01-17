--
-- This code has been generated with LLM and I'm not proud of it
-- This code helps me to navigate easily between a source file and its tests
--
local load_projections = require("altestnate.utils").load_projections
-- local function load_projections()
--   local projections_file = vim.fn.getcwd() .. "/.projections.json"
--
--   if vim.fn.filereadable(projections_file) == 1 then
--     -- If the file exists, read and decode its contents
--     local content = vim.fn.readfile(projections_file)
--     local decoded = vim.fn.json_decode(table.concat(content, "\n"))
--     return decoded
--   else
--     -- If the file doesn't exist, prompt to create it
--     local confirm = vim.fn.input("No .projections.json file found. Create it? (y/n): ")
--     if confirm:lower() == "y" then
--       -- Default template for .projections.json
--       local default_template = [[
-- {
--   "src/*.ts": {
--     "alternate": "src/__tests__/{basename}.test.ts",
--     "type": "source"
--   },
--   "src/__tests__/*.test.ts": {
--     "alternate": "src/{basename}.ts",
--     "type": "test"
--   }
-- }
-- ]]
--       -- Create the .projections.json file with the default template
--       vim.fn.writefile(vim.fn.split(default_template, "\n"), projections_file)
--       print(".projections.json has been created with a basic template!")
--     else
--       print("Aborted.")
--     end
--     return {}
--   end
-- end
local projections = load_projections()

-- Find the alternate file based on patterns
local find_alternate = require("altestnate.utils").find_alternate
-- local function find_alternate()
--   local current_file = vim.fn.expand("%:p") -- Get the full path of the current file
--   local project_root = vim.fn.getcwd() -- Get the project root directory
--   for pattern, config in pairs(projections) do
--     -- Convert the JSON pattern to a Lua regex
--     local lua_pattern = project_root .. "/" .. pattern:gsub("%*", "(.*)")
--     local match = { current_file:match(lua_pattern) }
--     if #match > 0 then
--       -- Replace {basename} with the captured part
--       local alternate = config.alternate:gsub("{basename}", match[1])
--       -- Construct the full path of the alternate file
--       return project_root .. "/" .. alternate
--     end
--   end
--   return nil
-- end

-- Create the alternate file if the user agrees
local create_file = require("altestnate.utils").create_file

-- Toggle between source and test files
local function toggle_alternate()
  local alternate = find_alternate()
  if alternate then
    if vim.fn.filereadable(alternate) == 1 then
      vim.cmd("edit " .. alternate)
    else
      create_file(alternate)
    end
  else
    print("No alternate file found!")
  end
end

-- Function to split and open the alternate file in a vertical split
local function split_and_open_alternate()
  local alternate = find_alternate()
  if alternate then
    -- Perform a vertical split and open the alternate file
    vim.cmd("vsplit " .. alternate)
  else
    print("No alternate file found!")
  end
end

local M = {}

function M.setup()
  print("Hello from altestnate")
  -- Keymap to toggle alternate
  vim.api.nvim_create_user_command("FindAlternate", find_alternate, {})
  vim.api.nvim_create_user_command("ToggleAlternate", toggle_alternate, {})
  -- Keymap to toggle alternate (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>at", toggle_alternate)
  -- Keymap to open alternate in a split (split vertically and open the alternate file)
  vim.keymap.set("n", "<leader>as", split_and_open_alternate, { noremap = true, silent = true })
end

return M
