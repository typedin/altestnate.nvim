local test_util = require("tests.test_util")

describe("util", function()
  after_each(function()
    test_util.reset_editor()
  end)

  local projections_file = vim.fn.expand(".test_projections_file.json")

  before_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  after_each(function()
    test_util.reset_editor()
    os.execute("rm -rf " .. projections_file)
  end)

  describe("load default projection file", function()
    it("creates a projections file when the user confirms", function()
      vim.schedule(function()
        require("altestnate").setup({
          projections_file = projections_file,
        })
        require("altestnate.util").load_projections(projections_file)
      end)
      assert.is_false(vim.fn.filereadable(projections_file) == 1)

      vim.api.nvim_feedkeys("y\n", "n", true)

      vim.wait(1000, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_true(vim.fn.filereadable(projections_file) == 1)
    end)

    it("doesn't create a projections file when the user abort", function()
      vim.schedule(function()
        require("altestnate").setup({
          projections_file = projections_file,
        })
        require("altestnate.util").load_projections(projections_file)
      end)
      assert.is_false(vim.fn.filereadable(projections_file) == 1)

      vim.api.nvim_feedkeys("n\n", "n", true)

      vim.wait(1000, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_false(vim.fn.filereadable(projections_file) == 1)
    end)
  end)
end)
