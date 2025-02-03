local test_util = require("tests.test_util")

describe("Edit project file", function()
  after_each(function()
    test_util.reset_editor()
  end)

  local projections_file = vim.fn.expand(".test_projections_file.json")

  before_each(function()
    os.execute("touch " .. projections_file)
    vim.wait(1000, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 50)
  end)

  after_each(function()
    test_util.reset_editor()
    os.execute("rm -rf " .. projections_file)
  end)

  it("succeeds when the users confirm", function()
    -- Make sure the projections file is readable before starting
    assert.is_true(vim.fn.filereadable(projections_file) == 1)

    -- Schedule the setup and file opening
    vim.schedule(function()
      require("altestnate").setup({
        projections_file = projections_file,
      })
      require("altestnate.fs").edit_projection(projections_file)
    end)

    -- Wait for the buffer to open (this will ensure the file is loaded)
    vim.wait(500, function()
      return vim.fn.bufloaded(vim.fn.bufname(0)) == 1
    end, 50)

    -- Sanity check: Feed keys to the prompt after the file is loaded
    vim.api.nvim_feedkeys("y\n", "n", true)

    -- Assert that the correct file was opened in the buffer, we don't care about the full path
    local filename_with_extension = vim.fn.fnamemodify(vim.fn.expand(vim.api.nvim_buf_get_name(0)), ":t")
    assert.is_same(filename_with_extension, projections_file)
  end)
end)
