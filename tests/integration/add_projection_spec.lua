local feedkeys = require("tests.test_util").feedkeys
local json = vim.fn.json_decode -- Use Neovim's built-in JSON decoder
local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

describe("A user can populate their own projection file by interacting with the plugin", function()
  describe("valid user input", function()
    after_each(function()
      os.execute("rm -rf " .. projections_file)
    end)

    it("creates a fully functionning projection file with valid values", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })

      vim.defer_fn(function()
        local parsed_content = json(vim.fn.readfile(projections_file))
        local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
        assert.same(expected_content, parsed_content)
      end, 100)
    end)

    it("adds to an existing projection file", function()
      vim.schedule(function()
        -- create a projection file with some content
        os.execute("cp tests/fixtures/expected.json " .. projections_file)
        vim.api.nvim_command("AddProjection")
      end)
      --
      feedkeys({ step1 = "lua/init.lua", step2 = "spec", step3 = "_test" })

      vim.defer_fn(function()
        local parsed_content = json(vim.fn.readfile(projections_file))
        local expected_content = json(vim.fn.readfile("tests/fixtures/merged.json"))
        assert.same(expected_content, parsed_content)
      end, 100)
    end)

    it("adds to an existing projection empty file", function()
      vim.schedule(function()
        -- create a projection file with some content
        os.execute("touch " .. projections_file)
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })

      vim.defer_fn(function()
        local parsed_content = json(vim.fn.readfile(projections_file))
        local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
        assert.same(expected_content, parsed_content)
      end, 100)
    end)
  end)

  describe("invalid user input", function()
    it("doesn't create anything when the user aborts at first step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "", step2 = "tests", step3 = "_spec" })

      vim.defer_fn(function()
        assert.is_false(vim.fn.filereadable(projections_file) == 1)
      end, 100)
    end)

    it("doesn't create anything when the user aborts at second step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "", step3 = "_spec" })

      vim.defer_fn(function()
        assert.is_false(vim.fn.filereadable(projections_file) == 1)
      end, 100)
    end)

    it("doesn't create anything when the user aborts at third step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "" })

      vim.defer_fn(function()
        assert.is_false(vim.fn.filereadable(projections_file) == 1)
      end, 100)
    end)
  end)
end)
