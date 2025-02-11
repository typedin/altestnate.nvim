local json = vim.fn.json_decode -- Use Neovim's built-in JSON decoder
local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

describe("CreateProjectionsFile command", function()
  after_each(function()
    os.remove(projections_file)
  end)

  it("creates a fully functionning projection file with valid values", function()
    vim.api.nvim_command("CreateProjectionsFile")

    local parsed_content = json(vim.fn.readfile(projections_file))
    local expected_content = json({ "{}" })
    assert.same(expected_content, parsed_content)
  end)

  it("doesn't create anything when the file already exists", function()
    vim.fn.writefile({ "{}" }, projections_file)
    vim.api.nvim_command("CreateProjectionsFile")

    local messages = vim.fn.execute("messages")
    local last_line = messages:match("([^\n]*)\n?$")
    assert.same(last_line, "Could not create the file")
  end)
end)
