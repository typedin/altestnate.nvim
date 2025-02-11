local json = vim.fn.json_decode -- Use Neovim's built-in JSON decoder
local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

local function send_key(key)
  local termcode = vim.api.nvim_replace_termcodes(key .. "\n", true, false, true)
  vim.api.nvim_feedkeys(termcode, "n", false)
end

---@param args table
local function feedkeys(args)
  vim.defer_fn(function()
    send_key(args.step1)
  end, 100)
  vim.defer_fn(function()
    send_key(args.step2)
  end, 200)
  vim.defer_fn(function()
    send_key(args.step3)
  end, 300)
end

describe("AddProjection command", function()
  describe("with valid user input", function()
    after_each(function()
      os.execute("rm -rf " .. projections_file)
    end)

    it("creates a fully functionning projection file", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })

      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local parsed_content = json(vim.fn.readfile(projections_file))
      local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
      assert.same(expected_content, parsed_content)
    end)

    it("adds to an existing projection empty file", function()
      vim.schedule(function()
        -- create a projection file with some content
        os.execute("touch " .. projections_file)
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local parsed_content = json(vim.fn.readfile(projections_file))
      local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
      assert.same(expected_content, parsed_content)
    end)

    it("adds to an existing projection with empty json", function()
      vim.schedule(function()
        -- create a projection file with some content
        os.execute("echo {} >> " .. projections_file)
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "_spec" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local parsed_content = json(vim.fn.readfile(projections_file))
      local expected_content = json(vim.fn.readfile("tests/fixtures/expected.json"))
      assert.same(expected_content, parsed_content)
    end)

    it("adds to an existing projection file", function()
      vim.schedule(function()
        -- create a projection file with some content
        os.execute("cp tests/fixtures/expected.json " .. projections_file)
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "lua/init.lua", step2 = "spec", step3 = "_test" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local parsed_content = json(vim.fn.readfile(projections_file))
      local expected_content = json(vim.fn.readfile("tests/fixtures/merged.json"))
      assert.same(expected_content, parsed_content)
    end)
  end)

  describe("with invalid user input", function()
    it("at the first step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "", step2 = "tests", step3 = "_spec" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_false(vim.fn.filereadable(projections_file) == 1)
    end)

    it("at the second step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "", step3 = "_spec" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_false(vim.fn.filereadable(projections_file) == 1)
    end)

    it("at the third step", function()
      vim.schedule(function()
        vim.api.nvim_command("AddProjection")
      end)

      feedkeys({ step1 = "src/init.lua", step2 = "tests", step3 = "" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      assert.is_false(vim.fn.filereadable(projections_file) == 1)
    end)
  end)
end)
