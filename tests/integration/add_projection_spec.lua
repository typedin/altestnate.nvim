local json = vim.fn.json_decode -- Use Neovim's built-in JSON decoder
local projections_file = vim.fn.expand(".test_projections_file.json")
require("altestnate").setup({
  projections_file = projections_file,
})

---@param args table
local function feedkeys(args)
  -- Example of a source file (ex: src/init.lua):
  vim.api.nvim_feedkeys(args.step1 .. "\n", "n", true)
  -- Test folder for this source f .. "\n",le (ex: tests):
  vim.api.nvim_feedkeys(args.step2 .. "\n", "n", true)
  -- Suffix for the source file (e .. "\n",: _spec)
  vim.api.nvim_feedkeys(args.step3 .. "\n", "n", true)
end

describe("A user can populate their own projection file by interacting with the plugin", function()
  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("creates a fully functionning projection file with valid values", function()
    vim.schedule(function()
      vim.api.nvim_command("AddProjection")
    end)

    feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    local parsed_content = json(vim.fn.readfile(projections_file))
    local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
    assert(vim.deep_equal(parsed_content, expected_content), "File content does not match")
  end)

  it("doesn't create anything when the user aborts at first step", function()
    vim.schedule(function()
      vim.api.nvim_command("AddProjection")
    end)

    feedkeys({ step1 = "", step2 = "tests", step3 = "_spec" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    assert.is_false(vim.fn.filereadable(projections_file) == 1)
  end)

  it("doesn't create anything when the user aborts at second step", function()
    vim.schedule(function()
      vim.api.nvim_command("AddProjection")
    end)

    feedkeys({ step1 = "src/init.lua", step2 = "", step3 = "_spec" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    assert.is_false(vim.fn.filereadable(projections_file) == 1)
  end)

  it("doesn't create anything when the user aborts at third step", function()
    vim.schedule(function()
      vim.api.nvim_command("AddProjection")
    end)

    feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    assert.is_false(vim.fn.filereadable(projections_file) == 1)
  end)

  it("adds to an existing projection file", function()
    vim.schedule(function()
      -- create a projection file with some content
      os.execute("cp tests/fixtures/expected.json " .. projections_file)
      vim.api.nvim_command("AddProjection")
    end)
    --
    feedkeys({ step1 = "lua/init.lua", step2 = "spec", step3 = "_test" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    local parsed_content = json(vim.fn.readfile(projections_file))
    local expected_content = json(vim.fn.readfile("tests/fixtures/merged.json"))
    assert.same(expected_content, parsed_content)
  end)

  it("adds to an existing projection empty file", function()
    vim.schedule(function()
      -- create a projection file with some content
      os.execute("touch " .. projections_file)
      vim.api.nvim_command("AddProjection")
    end)

    feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })
    -- Wait for the file to be written
    vim.wait(500, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)

    local parsed_content = json(vim.fn.readfile(projections_file))
    local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
    assert(vim.deep_equal(parsed_content, expected_content), "File content does not match")
  end)
end)
