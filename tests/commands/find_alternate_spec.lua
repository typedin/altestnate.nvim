local find_alternate = require("altestnate.commands.find_alternate").find_alternate
local projections = require("tests.fixtures.projections")
local test_util = require("tests.test_util")

describe("find_alternate", function()
  describe("for source files", function()
    after_each(function()
      test_util.reset_editor()
    end)

    it("finds the alternate test file for a TypeScript source file with underscore", function()
      local file_path = "src/source_file.ts"

      local result = find_alternate(projections, file_path)

      assert.are.same("src/__tests__/source_file.test.ts", result)
    end)
    it("finds the alternate test file for a TypeScript source file", function()
      local file_path = "src/file.ts"

      local result = find_alternate(projections, file_path)

      assert.are.same("src/__tests__/file.test.ts", result)
    end)
    it("finds the alternate test file for a general PHP source file", function()
      local file_path = "src/MyClass.php"

      local result = find_alternate(projections, file_path)

      assert.are.same("tests/MyClassTest.php", result)
    end)
    it("finds the alternate test file for an Actions PHP source file", function()
      local file_path = "src/Actions/MyAction.php"

      local result = find_alternate(projections, file_path)

      assert.are.same("tests/Actions/MyActionTest.php", result)
    end)
    it("finds the alternate test file for a lua source file", function()
      local file_path = "lua/file.lua"

      local result = find_alternate(projections, file_path)

      assert.are.same("tests/file_spec.lua", result)
    end)
  end)

  describe("for test files", function()
    after_each(function()
      test_util.reset_editor()
    end)

    it("finds the alternate source file for a TypeScript file with underscore", function()
      local file_path = "src/source_file.ts"

      local result = find_alternate(projections, file_path)

      assert.are.same("src/__tests__/source_file.test.ts", result)
    end)

    it("finds the alternate source file for a TypeScript test file", function()
      local file_path = "src/__tests__/file.test.ts"

      local result = find_alternate(projections, file_path)

      assert.are.same("src/file.ts", result)
    end)

    it("finds the alternate source file for a general PHP test file", function()
      local file_path = "tests/MyClassTest.php"

      local result = find_alternate(projections, file_path)

      assert.are.same("src/MyClass.php", result)
    end)

    it("finds the alternate source file for an Actions PHP test file", function()
      local file_path = "src/Actions/MyAction.php"

      local result = find_alternate(projections, file_path)

      assert.are.same("tests/Actions/MyActionTest.php", result)
    end)

    it("finds the alternate source file for a lua test file", function()
      local file_path = "tests/file_spec.lua"

      local result = find_alternate(projections, file_path)

      assert.are.same("lua/file.lua", result)
    end)

    it("finds the alternate source file for a lua test file in a plugin context", function()
      local file_path = "tests/commands/find_alternate_spec.lua"

      local result = find_alternate(projections, file_path)

      assert.are.same("lua/plugins/commands/file.lua", result)
    end)
  end)
end)
