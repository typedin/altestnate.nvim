local input_to_json_string = require("altestnate.utils.input_to_json_string")

describe("input_to_json_string", function()
  it("parse a table", function()
    local input = "src/index.ts src/__tests__ .test"
    local expected =
      '{"src/*.ts":{"alternate":"src/__tests__/{}.test.ts","type":"source"},"src/__tests__/*.test.ts":{"alternate":"src/{}.ts","type":"test"}}'
    local result = input_to_json_string(input)

    assert.are.same(vim.fn.json_decode(expected), vim.fn.json_decode(result))
  end)
end)
