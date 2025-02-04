local projections_file = vim.fn.expand(".test_projections_file.json")
require("altestnate").setup({
  projections_file = projections_file,
})

describe("A user can populate their own projection file by interacting with the plugin", function()
  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  -- -- TODO
  -- -- either the user wants to edit themselves
  -- -- or they want a step by step guide
  -- -- or they want to leave it as it
  it("creates a fully functionning projection file", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    vim.api.nvim_feedkeys("y\n", "n", true)

    -- Edit the projections file? (y/n):
    vim.api.nvim_feedkeys("y\n", "n", true)

    -- Enter choices (space-separated):
    vim.api.nvim_feedkeys("src/init.lua tests _spec\n", "n", true)
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    assert.is_true(vim.fn.filereadable(projections_file) == 1)
  end)
end)
