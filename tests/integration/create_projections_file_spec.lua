local projections_file = vim.fn.expand(".test_projections_file.json")
require("altestnate").setup({
  projections_file = projections_file,
})

describe("A user can populate their own projection file by interacting with the plugin", function()
  after_each(function()
    if vim.fn.filereadable(projections_file) == 1 then
      os.remove(projections_file)
    end
  end)

  it("creates a fully functionning projection file with valid values", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    vim.api.nvim_feedkeys("y\n", "n", true)

    vim.defer_fn(function()
      assert(vim.fn.filereadable(projections_file) == 1, "File should exist")
    end, 500) -- Wait 500ms before running the assertion
  end)

  it("doesn't create anything when the user aborts", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    vim.api.nvim_feedkeys("n\n", "n", true)

    -- Defer the assertion to ensure Neovim has processed the input
    vim.defer_fn(function()
      assert(vim.fn.filereadable(projections_file) == 0, "File should not exist")
    end, 500) -- Wait 500ms before running the assertion
  end)
end)
