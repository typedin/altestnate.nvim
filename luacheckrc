max_comment_line_length = false
codes = true

exclude_files = {
  "tests/treesitter",
}

ignore = {
  "122", -- Setting a readonly global
  "212", -- Unused argument
  "542", -- Empty if branch
  "631", -- Line is too long
}

read_globals = {
  "assert",
  "it",
  "vim",
}
