local projections_file = vim.fn.expand(".test_projections_file.json")
require("altestnate").setup({
  projections_file = projections_file,
})

describe("A user can populate their own projection file by interacting with the plugin", function()
  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("creates a fully functionning projection file with valid values", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    vim.api.nvim_feedkeys("y\n", "n", true)

    -- Enter choices (space-separated):
    vim.api.nvim_feedkeys("src/init.lua tests _spec\n", "n", true)
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    assert.is_true(vim.fn.filereadable(projections_file) == 1)
  end)

  it("doesn't create anything when the user aborts", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    vim.api.nvim_feedkeys("y\n", "n", true)

    assert.is_false(vim.fn.filereadable(projections_file) == 1)
  end)
end)
