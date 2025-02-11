local projections_file = vim.fn.expand(".test_projections_file.json")

require("tests.test_util").start_plugin({
  projections_file = projections_file,
})

describe("EditProjectionsFile command", function()
  before_each(function()
    os.execute("touch " .. projections_file)
  end)

  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("opens a buffer with the projections file loaded", function()
    vim.schedule(function()
      vim.api.nvim_command("EditProjectionsFile")
    end)

    vim.wait(500, function()
      return vim.api.nvim_buf_get_name(0) == projections_file
    end, 50)

    -- Assert that the correct file was opened in the buffer, we don't care about the full path
    local filename_with_extension = vim.fn.fnamemodify(vim.fn.expand(vim.api.nvim_buf_get_name(0)), ":t")
    assert.is_same(filename_with_extension, projections_file)
  end)
end)
