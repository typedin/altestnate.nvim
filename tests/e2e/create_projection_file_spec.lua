local projections_file = vim.fn.expand(".test_projections_file.json")
require("altestnate").setup({
  projections_file = projections_file,
})

describe("Projection file creation", function()
  after_each(function()
    os.execute("rm -rf " .. projections_file)
  end)

  it("succeeds when the user confirms", function()
    vim.schedule(function()
      require("altestnate.fs").load_projections(projections_file)
    end)
    assert.is_false(vim.fn.filereadable(projections_file) == 1)

    vim.api.nvim_feedkeys("y\n", "n", true)

    vim.wait(50, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 10)

    assert.is_true(vim.fn.filereadable(projections_file) == 1)
  end)

  it("doesn't succeed when the user abort", function()
    vim.schedule(function()
      require("altestnate.fs").load_projections(projections_file)
    end)
    assert.is_false(vim.fn.filereadable(projections_file) == 1)

    vim.api.nvim_feedkeys("n\n", "n", true)

    vim.wait(50, function()
      return vim.fn.filereadable(projections_file) == 1
    end, 10)

    assert.is_false(vim.fn.filereadable(projections_file) == 1)
  end)
end)
