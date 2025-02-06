local M = {
  -- mini.test
  ["lua/*.lua"] = {
    alternate = "tests/spec_{}.lua",
    type = "source",
  },
  ["tests/spec_*.lua"] = {
    alternate = "lua/{}.lua",
    type = "test",
  },
}
return M
