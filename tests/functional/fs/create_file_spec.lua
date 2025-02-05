local create_file = require("altestnate.fs.create_file")
local file_exists = require("tests.test_util").file_exists

describe("create alternate file", function()
  local path = "tests/some/where/over.lua"
  after_each(function()
    os.remove(path)
  end)

  it("creates an alternate file on a non existing path", function()
    assert.is_false(file_exists(path))

    -- if there is an error -1 is returned otherwise 0
    local result = create_file({}, path)

    assert.is_true(file_exists(path))
    assert.equal(result, 0)
  end)

  it("doesn't create an alternate file when the file exists", function()
    -- this file !
    assert.is_true(file_exists("tests/functional/fs/create_file_spec.lua"))

    -- -- if there is an error -1 is returned otherwise 0
    local result = create_file({}, "tests/functional/fs/create_file_spec.lua")

    assert.is_true(result == -1)
    assert.is_true(file_exists("tests/functional/fs/create_file_spec.lua"))
  end)
end)
