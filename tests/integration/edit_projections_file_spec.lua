local feedkeys = require("tests.test_util").feedkeys
local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

describe("Edit project file", function()
  before_each(function()
    os.execute("touch " .. projections_file)
  end)

  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("succeeds when the users confirm", function()
    vim.schedule(function()
      vim.api.nvim_command("EditProjectionsFile")
    end)

    -- Edit the projections file? (y/n):
    feedkeys({ step1 = "y" })

    -- wait for the buffer to be load in nvim
    vim.defer_fn(function()
      -- Assert that the correct file was opened in the buffer, we don't care about the full path
      local filename_with_extension = vim.fn.fnamemodify(vim.fn.expand(vim.api.nvim_buf_get_name(0)), ":t")
      assert.is_same(filename_with_extension, projections_file)
    end, 100)
  end)
end)
