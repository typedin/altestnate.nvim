local test_util = require("tests.test_util")

describe("util", function()
  after_each(function()
    test_util.reset_editor()
  end)

  describe("load default projection file", function()
    local projections_file = vim.fn.expand(".projections.json")
    local function cleanup()
      if vim.fn.filereadable(projections_file) == 1 then
        os.remove(projections_file)
      end
    end

    before_each(function()
      cleanup()
    end)

    after_each(function()
      cleanup()
    end)

    it("creates a .projections.json when the user confirms", function()
      vim.schedule(function()
        require("altestnate.fs").load_projections()
      end)
      assert.is_false(vim.fn.filereadable(projections_file) == 1)

      vim.api.nvim_feedkeys("y\n", "n", true)

      vim.wait(1000, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_true(vim.fn.filereadable(projections_file) == 1)
    end)

    it("doesn't create a .projections.json when the user abort", function()
      vim.schedule(function()
        require("altestnate.fs").load_projections()
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
