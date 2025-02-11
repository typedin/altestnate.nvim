local create_file = require("altestnate.fs.create_file")
local create_projections_entry = require("altestnate.utils.create_projections_entry")
local find_alternate = require("altestnate.fs.find_alternate")
local load_projections = require("altestnate.fs.load_projections")

---@class AltestnateCommand
local M = {}

local function get_projections_file()
  return require("altestnate").get("projections_file")
end

---Private function
---read :h expand
---@return string | nil
local function get_alternate_path()
  local projections = load_projections(get_projections_file())
  return find_alternate(projections, vim.fn.expand("%:p"))
end

M.create_projections_file = function()
  -- Create a projections file to the disk
  -- the default template is a empty json file
  if create_file({ "{}" }, get_projections_file()) == -1 then
    vim.notify("\nCould not create the file", vim.log.levels.WARN)
  end
end

M.add_projection = function()
  local user_input = {
    entry_key = { value = "", prompt = "Source file for a projection (ex: src/init.lua) :" },
    test_folder = { value = "", prompt = "Test folder for this source file (ex: tests): " },
    test_suffix = { value = "", prompt = "Suffix for the source file (ex: _spec): " },
  }

  vim.ui.input({ prompt = user_input["entry_key"].prompt }, function(input)
    if #input == 0 then
      vim.notify("\nNo input provided.", vim.log.levels.INFO)
      return
    end
    user_input["entry_key"].value = input
  end)
  vim.ui.input({ prompt = user_input["test_folder"].prompt }, function(input)
    if #input == 0 then
      vim.notify("\nNo input provided.", vim.log.levels.INFO)
      return
    end
    user_input["test_folder"].value = input
  end)
  vim.ui.input({ prompt = user_input["test_suffix"].prompt }, function(input)
    if #input == 0 then
      vim.notify("\nNo input provided.", vim.log.levels.INFO)
      return
    end
    user_input["test_suffix"].value = input
  end)

  -- that should be redondant
  if #user_input.test_suffix.value == 0 or #user_input.test_folder.value == 0 or #user_input.entry_key.value == 0 then
    vim.notify("\nNo valid input provided", vim.log.levels.INFO)
    return
  end

  local function existing_content()
    if vim.fn.filereadable(get_projections_file()) ~= 1 then
      return {}
    end
    local file_content = vim.fn.readfile(get_projections_file())
    if #file_content == 0 then
      return {}
    end
    return vim.fn.json_decode(file_content)
  end

  -- read the file and append the new content
  local merged = vim.tbl_deep_extend(
    "force",
    create_projections_entry({
      entry_key = user_input["entry_key"].value,
      test_folder = user_input["test_folder"].value,
      test_suffix = user_input["test_suffix"].value,
    }),
    existing_content()
  )

  vim.fn.writefile({ vim.fn.json_encode(merged) }, get_projections_file())
end

M.edit_projections_file = function()
  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. get_projections_file())
end

-- Toggle between source and test files
function M.toggle_alternate()
  local alternate_path = get_alternate_path()
  if alternate_path == nil then
    vim.notify("No alternate file found!", vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(alternate_path) ~= 1 then
    create_file({}, alternate_path)
  end
  -- edit the alternate file
  vim.cmd("edit " .. alternate_path)
end

-- Function to split and open the alternate file in a vertical split
function M.split_open_alternate()
  local alternate_path = get_alternate_path()
  if alternate_path == nil then
    vim.notify("No alternate file found!", vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(alternate_path) ~= 1 then
    create_file({}, alternate_path)
  end
  -- vertical split and open the alternate file
  vim.cmd("vsplit " .. alternate_path)
end

return M
