local feedkeys = require("tests.test_util").feedkeys
local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

describe("A user can populate their own projection file by interacting with the plugin", function()
  after_each(function()
    os.remove(projections_file)
  end)

  it("creates a fully functionning projection file with valid values", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    feedkeys({ step1 = "y" })

    vim.defer_fn(function()
      assert(vim.fn.filereadable(projections_file) == 1, "File should exist")
    end, 100)
  end)

  it("doesn't create anything when the user aborts", function()
    vim.schedule(function()
      vim.api.nvim_command("CreateProjectionsFile")
    end)

    -- Create a projections file? (y/n):
    feedkeys({ step1 = "y" })

    -- Defer the assertion to ensure Neovim has processed the input
    vim.defer_fn(function()
      assert(vim.fn.filereadable(projections_file) == 0, "File should not exist")
    end, 100)
  end)
end)
