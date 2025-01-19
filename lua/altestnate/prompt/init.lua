local M = {}

M.prompt = function(args, callback)
  vim.ui.input({
    prompt = args.prompt,
  }, function(input)
    if input:lower() == "y" then
      callback()
    else
      print("\nAborted.")
    end
  end)
end

return M
