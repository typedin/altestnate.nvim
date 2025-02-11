local find_alternate = require("altestnate.fs.find_alternate")
local projections = require("tests.fixtures.projections")

describe("find_alternate", function()
  describe("for source files", function()
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

    it("finds the alternate test file for a deeply nested source file", function()
      local nested_projections = {
        ["lua/altestnate/*.lua"] = {
          alternate = "tests/functional/{}_spec.lua",
          type = "source",
        },
      }
      local file_path = "lua/altestnate/fs/file.lua"

      local result = find_alternate(nested_projections, file_path)

      assert.are.same("tests/functional/fs/file_spec.lua", result)
    end)

    it("gets alternate test file for _prefix_", function()
      local inverted = require("tests.fixtures.inverted")
      local file_path = "lua/file.lua"

      local result = find_alternate(inverted, file_path)

      assert.are.same("tests/spec_file.lua", result)
    end)
  end)

  describe("for test files", function()
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

    it("finds the alternate source file for a deeply nested test file", function()
      local nested_projections = {
        ["tests/functional/*_spec.lua"] = {
          alternate = "lua/altestnate/{}.lua",
          type = "test",
        },
      }
      local file_path = "tests/functional/fs/file_spec.lua"

      local result = find_alternate(nested_projections, file_path)

      assert.are.same("lua/altestnate/fs/file.lua", result)
    end)

    it("gets alternate source file for _prefix_", function()
      local inverted = require("tests.fixtures.inverted")
      local file_path = "tests/spec_file.lua"

      local result = find_alternate(inverted, file_path)

      assert.are.same("lua/file.lua", result)
    end)

    it("gets no alternate for source that has been ruled out", function()
      local file_path = "should/not/have/projection/index.lua"
      local ruled_out = {
        ["lua/*.lua"] = {
          alternate = "tests/{}_spec.lua",
          type = "source",
        },
        ["tests/*_spec.lua"] = {
          alternate = "lua/{}.lua",
          type = "test",
        },
        ["should/not/have/projection/index.lua"] = {
          alternate = "",
          type = "source",
        },
      }

      local result = find_alternate(ruled_out, file_path)

      assert.is_nil(result)
    end)
    it("gets no alternate for test file that has been ruled out", function()
      local file_path = "tests/should/not/have/projection/index_spec.lua"
      local ruled_out = {
        ["lua/*.lua"] = {
          alternate = "tests/{}_spec.lua",
          type = "source",
        },
        ["tests/*_spec.lua"] = {
          alternate = "lua/{}.lua",
          type = "test",
        },
        ["tests/should/not/have/projection/*_spec.lua"] = {
          alternate = "",
          type = "test",
        },
      }

      local result = find_alternate(ruled_out, file_path)

      assert.is_nil(result)
    end)
  end)
end)
