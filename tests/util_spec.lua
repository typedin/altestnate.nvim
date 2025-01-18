local test_util = require("tests.test_util")

local projections = {
  ["src/*.ts"] = {
    alternate = "src/__tests__/{basename}.test.ts",
    type = "source",
  },
  ["src/__tests__/*.test.ts"] = {
    alternate = "src/{basename}.ts",
    type = "test",
  },
}

describe("util", function()
  after_each(function()
    test_util.reset_editor()
  end)

  describe("find_alternate", function()
    it("returns the correct alternate test file for a source file", function()
      vim.cmd.edit({ args = { "src/source_file.ts" } })

      local result = require("altestnate.util").find_alternate(projections)

      assert.are.same("src/__tests__/source_file.test.ts", result)
    end)

    it("returns the correct alternate source file for a test file", function()
      vim.cmd.edit({ args = { "src/__tests__/file.test.ts" } })

      local result = require("altestnate.util").find_alternate(projections)

      assert.are.same("src/file.ts", result)
    end)
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
        require("altestnate.util").load_projections()
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
        require("altestnate.util").load_projections()
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
