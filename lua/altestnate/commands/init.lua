local create_file = require("altestnate.fs.create_file")
local create_projection_entry = require("altestnate.utils.create_projection_entry")
local find_alternate = require("altestnate.fs.find_alternate")
local load_projections = require("altestnate.fs.load_projections")
local user_input = require("altestnate.commands.user_input")

---Private functions

---Get the path of the projections file
---@return string
local function get_projections_file()
  ---@diagnostic disable-next-line: return-type-mismatch
  return require("altestnate").get("projections_file")
end

---Get the flag that turns off a projection for a file
---@return string: The flag that can be used to prevent file from having projection can be an empty string, a word (eg: NOP)
local function get_no_alternate_flag()
  ---@diagnostic disable-next-line: return-type-mismatch
  return require("altestnate").get("no_alternate_flag")
end

---read :h expand
---@return string | nil
local function get_alternate_path()
  local projections = load_projections(get_projections_file())
  return find_alternate(projections, vim.fn.expand("%:p"), get_no_alternate_flag())
end

--- Read the file and append the new content
---A merged table of the projections already existing and the ones the user is adding
---@param args UserInput
---@return table A merged table of the projections already existing and the ones the user is adding
local do_merge = function(args)
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
  return vim.tbl_deep_extend("force", create_projection_entry(args), existing_content())
end

---@class AltestnateCommand
local M = {}

---Create a projection file to the disk
---@return nil
M.create_projections_file = function()
  if create_file({ "{}" }, get_projections_file()) == -1 then
    vim.notify("\nCould not create the file", vim.log.levels.WARN)
  end
end

---Add a projection to the projections file
---@return nil
M.add_projection = function()
  vim.ui.input({ prompt = user_input["entry_key"].prompt }, function(input)
    if #input == 0 then
      vim.notify(user_input["entry_key"].error, vim.log.levels.WARN)
      return
    end
    user_input["entry_key"].value = input
  end)
  vim.ui.input({ prompt = user_input["test_folder"].prompt }, function(input)
    if #input == 0 then
      vim.notify(user_input["test_folder"].error, vim.log.levels.WARN)
      return
    end
    user_input["test_folder"].value = input
  end)
  vim.ui.input({ prompt = user_input["test_suffix"].prompt }, function(input)
    if #input == 0 then
      vim.notify(user_input["test_suffix"].error, vim.log.levels.WARN)
      return
    end
    user_input["test_suffix"].value = input
  end)

  -- no empty values are valid
  if #user_input.test_suffix.value == 0 or #user_input.test_folder.value == 0 or #user_input.entry_key.value == 0 then
    return
  end

  local merged = do_merge({
    entry_key = user_input["entry_key"].value,
    test_folder = user_input["test_folder"].value,
    test_suffix = user_input["test_suffix"].value,
  })

  vim.fn.writefile({ vim.fn.json_encode(merged) }, get_projections_file())
end

---Add the file open in the current buffer to the projections file
---@return nil
M.add_file_as_projection = function()
  -- get the file path relative to the current working directory
  user_input["entry_key"].value = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")

  vim.ui.input({ prompt = user_input["test_folder"].prompt }, function(input)
    if #input == 0 then
      vim.notify(user_input["test_folder"].error, vim.log.levels.WARN)
      return
    end
    user_input["test_folder"].value = input
  end)
  vim.ui.input({ prompt = user_input["test_suffix"].prompt }, function(input)
    if #input == 0 then
      vim.notify(user_input["test_suffix"].error, vim.log.levels.WARN)
      return
    end
    user_input["test_suffix"].value = input
  end)

  -- no empty values are valid
  if #user_input.test_suffix.value == 0 or #user_input.test_folder.value == 0 or #user_input.entry_key.value == 0 then
    return
  end

  local merged = do_merge({
    entry_key = user_input["entry_key"].value,
    test_folder = user_input["test_folder"].value,
    test_suffix = user_input["test_suffix"].value,
  })

  vim.fn.writefile({ vim.fn.json_encode(merged) }, get_projections_file())
end

---Edit the projections file
---@return nil
M.edit_projections_file = function()
  vim.cmd("edit " .. vim.fn.getcwd() .. "/" .. get_projections_file())
end

---Toggle between source and test files
---@return nil
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

---Split and open the alternate file in a vertical split
---@return nil
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
