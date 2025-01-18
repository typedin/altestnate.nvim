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

  -- describe("find_alternate", function()
  --   it("returns the correct alternate test file for a source file", function()
  --     vim.cmd.edit({ args = { "src/source_file.ts" } })
  --
  --     local result = require("altestnate.util").find_alternate(projections)
  --
  --     assert.are.same("src/__tests__/source_file.test.ts", result)
  --   end)
  --
  --   it("returns the correct alternate source file for a test file", function()
  --     vim.cmd.edit({ args = { "src/__tests__/file.test.ts" } })
  --
  --     local result = require("altestnate.util").find_alternate(projections)
  --
  --     assert.are.same("src/file.ts", result)
  --   end)
  -- end)

  describe("load_projections", function()
    it("creates a .projections.json on the disk", function()
      assert.falsy(vim.fn.filereadable("./.projections") == 1)
      print("=== 1")
      print(vim.fn.getcmdline())
      print("=== 1")

      require("altestnate.util").load_projections()

      print("=== 2")
      print(vim.fn.getcmdline())
      print("=== 2")

      vim.api.nvim_input("y<CR>")
      assert.truthy(vim.fn.filereadable("./.projections") == 1)
    end)
  end)
end)
