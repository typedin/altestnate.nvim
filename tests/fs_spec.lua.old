local test_util = require("tests.test_util")

describe("fs", function()
  after_each(function()
    test_util.reset_editor()
  end)

  describe("creates a projection file", function()
    local function cleanup()
      if vim.fn.filereadable("./src/source.ts") == 1 then
        os.remove("./src/source.ts")
      end
    end
    before_each(function()
      cleanup()
    end)
    after_each(function()
      cleanup()
    end)

    it("creates an alternate file when the user confirms", function()
      assert.is_false(test_util.file_exists("./src/source.ts"))

      vim.schedule(function()
        require("altestnate.fs").create_alternate_file("./src/source.ts")
      end)

      vim.api.nvim_feedkeys("y\n", "n", true)

      vim.wait(1000, function()
        return vim.fn.filereadable("./src/source.ts") == 1
      end, 50)

      assert.is_true(test_util.file_exists("./src/source.ts"))
    end)

    it("doesn't create an alternate file when the user abort", function()
      assert.is_false(test_util.file_exists("./src/source.ts"))

      vim.schedule(function()
        require("altestnate.fs").create_alternate_file("./src/source.ts")
      end)

      vim.api.nvim_feedkeys("n\n", "n", true)

      vim.wait(1000, function()
        return vim.fn.filereadable("./src/source.ts") == 1
      end, 50)

      assert.is_false(test_util.file_exists("./src/source.ts"))
    end)
  end)
end)
