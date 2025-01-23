local create_projection_entry = require("altestnate.commands.create_projections_entry")

describe("create_projection_entry", function()
  it("creates a default empty structure with no entrie by default", function()
    local args = nil
    local result = create_projection_entry(args)

    assert.are.same(result, {})
  end)

  it("create a structure with the correct entry", function()
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
end)
