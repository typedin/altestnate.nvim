local altestnate = require("altestnate")
local M = {}

-- WARNING
-- this snippet is not used
M.reset_editor = function()
  vim.cmd.tabonly({ mods = { silent = true } })
  for i, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if i > 1 then
      vim.api.nvim_win_close(winid, true)
    end
  end
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(false, true))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

M.file_exists = function(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

M.start_plugin = function(opts)
  altestnate.setup(opts)
  altestnate.start_altestnate()
end

---@param args table
M.feedkeys = function(args)
  local function send_key(key)
    local termcode = vim.api.nvim_replace_termcodes(key .. "\n", true, false, true)
    vim.api.nvim_feedkeys(termcode, "n", false)
  end

  local wait_time = 100
  ---@diagnostic disable-next-line: unused-local
  for _key, value in pairs(args) do
    vim.defer_fn(function()
      send_key(value)
    end, wait_time)
    wait_time = wait_time + 100
  end
end

return M
