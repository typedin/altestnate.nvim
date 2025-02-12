local create_projection_entry = require("altestnate.utils.create_projection_entry")

describe("create_projection_entry", function()
  it("creates a default empty structure with no entrie by default", function()
    local args = nil
    local result = create_projection_entry(args)

    assert.are.same(result, {})
  end)

  it("create a projections pair with the correct entry", function()
    local args = {
      entry_key = "src/init.lua",
      test_folder = "tests",
      test_suffix = "_spec",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with a source path with a leading slash", function()
    local args = {
      entry_key = "/src/init.lua",
      test_folder = "tests",
      test_suffix = "_spec",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with a test path with a leading slash", function()
    local args = {
      entry_key = "/src/init.lua",
      test_folder = "/tests/",
      test_suffix = "_spec",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with a test path with a trailing slash", function()
    local args = {
      entry_key = "/src/init.lua",
      test_folder = "tests/",
      test_suffix = "_spec",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with a test path with a leading and a trailing slash", function()
    local args = {
      entry_key = "src/init.lua",
      test_folder = "/tests/",
      test_suffix = "_spec",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with prefix with underscore", function()
    local args = {
      entry_key = "src/init.lua",
      test_folder = "tests",
      test_suffix = "spec_",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.lua"] = {
        alternate = "tests/spec_{}.lua",
        type = "source",
      },
      ["tests/spec_*.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    })
  end)

  it("create a correct structure with prefix with dot", function()
    local args = {
      entry_key = "/src/index.ts",
      test_folder = "src/__tests__/",
      test_suffix = "test.",
    }

    local result = create_projection_entry(args)

    assert.are.same(result, {
      ["src/*.ts"] = {
        alternate = "src/__tests__/test.{}.ts",
        type = "source",
      },
      ["src/__tests__/test.*.ts"] = {
        alternate = "src/{}.ts",
        type = "test",
      },
    })
  end)
end)
