local load_projections = require("altestnate.fs.load_projections")
local projections_file = vim.fn.expand(".test_projections_file.json")

require("altestnate").setup({
  projections_file = projections_file,
})

describe("load projections", function()
  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("returns a lua table from a json file", function()
    os.execute("cp tests/fixtures/expected.json " .. projections_file)
    local expected = {
      ["src/*.lua"] = {
        alternate = "tests/{}_spec.lua",
        type = "source",
      },
      ["tests/*_spec.lua"] = {
        alternate = "src/{}.lua",
        type = "test",
      },
    }
    local result = load_projections(projections_file)
    assert.are.same(expected, result)
  end)

  it("returns an empty lua table for file not found", function()
    local expected = {}

    local result = load_projections(projections_file)

    assert.are.same(expected, result)
  end)
end)
