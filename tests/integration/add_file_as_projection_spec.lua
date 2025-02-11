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
end

describe("AddFileAsProjection command", function()
  describe("with valid user input", function()
    after_each(function()
      os.execute("rm -rf " .. projections_file)
    end)
    it("creates a new entry for a source file", function()
      vim.schedule(function()
        os.execute("echo {} >> " .. projections_file)
        vim.api.nvim_command("edit lua/utils/init.lua")
        vim.api.nvim_command("AddFileAsProjection")
      end)

      feedkeys({ step1 = "tests", step2 = "_spec" })

      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local parsed_content = json(vim.fn.readfile(projections_file))
      local expected_content = json(vim.fn.readfile("tests/fixtures/add-file-as-projection.json"))
      assert.same(parsed_content, expected_content)
    end)
  end)
  describe("with valid user input", function()
    after_each(function()
      os.execute("rm -rf " .. projections_file)
    end)
    it("at the first step", function()
      vim.schedule(function()
        os.execute("echo {} >> " .. projections_file)
        vim.api.nvim_command("edit lua/utils/init.lua")
        vim.api.nvim_command("AddFileAsProjection")
      end)

      feedkeys({ step1 = "", step2 = "_spec" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local messages = vim.fn.execute("messages")
      local last_line = messages:match("([^\n]*)\n?$")
      assert.same(last_line, "No input provided for test folder.")
    end)

    it("at the second step", function()
      vim.schedule(function()
        os.execute("echo {} >> " .. projections_file)
        vim.api.nvim_command("edit lua/utils/init.lua")
        vim.api.nvim_command("AddFileAsProjection")
      end)

      feedkeys({ step1 = "tests", step2 = "" })
      vim.wait(500, function()
        return vim.fn.filereadable(projections_file) == 1
      end, 50)

      local messages = vim.fn.execute("messages")
      local last_line = messages:match("([^\n]*)\n?$")
      assert.same(last_line, "No input provided for test suffix/prefix.")
    end)
  end)
end)
