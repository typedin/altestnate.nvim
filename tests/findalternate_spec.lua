local test_util = require("tests.test_util")
local find_alternate = require("altestnate.findalternate").find_alternate

local projections = {
  ["src/*.ts"] = {
    alternate = "src/__tests__/{basename}.test.ts",
    type = "source",
  },
  ["src/__tests__/*.test.ts"] = {
    alternate = "src/{basename}.ts",
    type = "test",
  },
  ["src/Actions/*.php"] = {
    alternate = "tests/Feature/{}Test.php",
    type = "source",
  },
  ["tests/Feature/*Test.php"] = {
    alternate = "src/Actions/{}.php",
    type = "test",
  },
  ["src/*.php"] = {
    alternate = "tests/{}Test.php",
    type = "source",
  },
  ["tests/*Test.php"] = {
    alternate = "src/{}.php",
    type = "test",
  },
  ["lua/*.lua"] = {
    alternate = "tests/{}_spec.lua",
    type = "source",
  },
  ["tests/*_spec.lua"] = {
    alternate = "lua/{}.lua",
    type = "test",
  },
}

describe("find_alternate", function()
  describe("for source files", function()
    after_each(function()
      test_util.reset_editor()
    end)
    it("returns the correct alternate test file", function()
      vim.cmd.edit({ args = { "src/source_file.ts" } })

      local result = find_alternate(projections)

      assert.are.same("src/__tests__/source_file.test.ts", result)
    end)
    it("finds the alternate test file for a PHP source file in Actions", function()
      vim.cmd.edit({ args = { "src/Actions/MyAction.php" } })

      local result = find_alternate(projections)

      assert.are.same("tests/Feature/MyActionTest.php", result)
    end)
    it("finds the alternate test file for a general PHP source file", function()
      vim.cmd.edit({ args = { "src/MyClass.php" } })

      local result = find_alternate(projections)

      assert.are.same("tests/MyClassTest.php", result)
    end)
    it("finds the alternate test file for a TypeScript source file", function()
      vim.cmd.edit({ args = { "src/file.ts" } })

      local result = find_alternate(projections)

      assert.are.same("src/__tests__/file.test.ts", result)
    end)
    it("finds the alternate test file for a PHP source file in Actions", function()
      vim.cmd.edit({ args = { "src/Actions/MyAction.php" } })

      local result = find_alternate(projections)

      assert.are.same("tests/Feature/MyActionTest.php", result)
    end)
    it("finds the alternate test file for a lua source file", function()
      vim.cmd.edit({ args = { "lua/file.lua" } })

      local result = find_alternate(projections)

      assert.are.same("tests/file_spec.lua", result)
    end)
  end)
  describe("for test files", function()
    after_each(function()
      test_util.reset_editor()
    end)
    -- it("returns the correct alternate source file for a test file", function()
    --   vim.cmd.edit({ args = { "src/__tests__/file.test.ts" } })
    --
    --   local result = find_alternate(projections)
    --
    --   assert.are.same("src/file.ts", result)
    -- end)
    --
    -- it("finds the alternate source file for a TypeScript test file", function()
    --   vim.cmd.edit({ args = { "src/__tests__/file.test.ts" } })
    --
    --   local result = find_alternate(projections)
    --
    --   assert.are.same("src/file.ts", result)
    -- end)
    --
    -- it("finds the alternate source file for a PHP test file in Feature", function()
    --   vim.cmd.edit({ args = { "tests/Actions/MyActionTest.php" } })
    --
    --   local result = find_alternate(projections)
    --
    --   assert.are.same("src/Actions/MyAction.php", result)
    -- end)
    --
    -- it("finds the alternate source file for a general PHP test file", function()
    --   vim.cmd.edit({ args = { "tests/MyClassTest.php" } })
    --
    --   local result = find_alternate(projections)
    --
    --   assert.are.same("src/MyClass.php", result)
    -- end)
    it("finds the alternate file for a lua test file", function()
      vim.cmd.edit({ args = { "tests/file_spec.lua" } })

      local result = find_alternate(projections)

      assert.are.same("lua/file.lua", result)
    end)
  end)
end)
