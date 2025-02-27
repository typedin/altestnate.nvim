local M = {
  ["src/*.ts"] = {
    alternate = "src/__tests__/{}.test.ts",
    type = "source",
  },
  ["src/__tests__/*.test.ts"] = {
    alternate = "src/{}.ts",
    type = "test",
  },
  ["src/Actions/*.php"] = {
    alternate = "tests/Actions/{}Test.php",
    type = "source",
  },
  ["tests/Actions/*Test.php"] = {
    alternate = "src/Actions/{}.php",
    type = "test",
  },
  ["src/Commands/*.php"] = {
    alternate = "tests/Commands/{}Test.php",
    type = "source",
  },
  ["tests/Commands/{}Test.php"] = {
    alternate = "src/Commands/*.php",
    type = "test",
  },
  ["src/*.php"] = {
    alternate = "tests/{}Test.php",
    type = "source",
  },
  ["tests/*Test.php"] = {
    alternate = "src/{}.php",
    type = "test",
  },
  ["lua/*.lua"] = {
    alternate = "tests/{}_spec.lua",
    type = "source",
  },
  ["tests/*_spec.lua"] = {
    alternate = "lua/{}.lua",
    type = "test",
  },
  ["should/not/have/projection/*.lua"] = {
    alternate = "NOPE",
    type = "source",
  },
}
return M
