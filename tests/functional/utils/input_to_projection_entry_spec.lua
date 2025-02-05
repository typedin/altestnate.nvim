local input_to_projection_entry = require("altestnate.utils.input_to_projection_entry")

describe("input_to_projection_entry", function()
  it("parse a table", function()
    local input = "src/index.ts src/__tests__ .test"
    local expected = {
      ["src/*.ts"] = {
        alternate = "src/__tests__/{}.test.ts",
        type = "source",
      },
      ["src/__tests__/*.test.ts"] = {
        alternate = "src/{}.ts",
        type = "test",
      },
    }
    local result = input_to_projection_entry(input)

    assert.are.same(expected, result)
  end)
end)
