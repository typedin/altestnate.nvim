# altestnate.nvim

**altestnate.nvim** is a Neovim plugin for easy navigation between test and source files with configurable key mappings. It integrates with Neovim's built-in user commands and allows you to quickly toggle between alternate files, open them in new splits, and manage projections files.
This work is a way to learn a bit about the lua programming language and the Neovim api. Ugly code to be expected.

## Features

- **Toggle between alternate test files** (e.g., from `.ts` to `.test.ts`, from `.lua` to `_spec.lua`).
- **Open alternate test files in a vertical split** for better side-by-side editing.
- **Edit and create projections files** for better management of your alternate file mappings.
- **Customizable key mappings** for easy access.
- the user **may change** the projections filename so it doesn't collide with [tpope's projectinist](https://github.com/tpope/vim-projectionist) 

## WIP
- **wip**: interact with the user to create a projections file
- **wip**: some folders may have no alternate (e.g.: e2e) maybe "alternate" = "NOPE" or ""

## Installation

You can use [Lazy.nvim](https://github.com/folke/lazy.nvim) to manage the plugin:

```lua
-- Example for Lazy.nvim
{
  "typedin/altestnate",
  opts = {
    keys = {
      { "<leader>at", "<cmd>ToggleAlternate<cr>", desc = "Toggle to alternate file" },
      { "<leader>as", "<cmd>SplitOpenAlternate<cr>", desc = "Open alternate file in new vertical split" },
      { "<leader>ae", "<cmd>EditProjectionsFile<cr>", desc = "Edit the projections file" },
      { "<leader>ac", "<cmd>CreateProjectionsFile<cr>", desc = "Create a projections file" },
    },
    projections_file = ".protestions.json",
  },
}
```
## Usage
### Key Mappings

By default, the plugin provides the following key mappings:

    <leader>at: Toggle between the alternate file.
    <leader>as: Open the alternate file in a vertical split.
    <leader>ae: Edit the projections file.
    <leader>ac: Create a projections file.

You can customize these key mappings by modifying the opts in the plugin setup.
Commands

    :ToggleAlternate – Toggle between the alternate file.
    :SplitOpenAlternate – Open the alternate file in a vertical split.
    :EditProjectionsFile – Edit the projections file.
    :CreateProjectionsFile – Create a projections file.

## Setup & Configuration

To configure the plugin, simply call the setup() function within your init.lua or config.lua:

```lua
require("altestnate").setup({
  keys = {
    { "<leader>at", "<cmd>ToggleAlternate<cr>", desc = "Toggle alternate file" },
    { "<leader>as", "<cmd>SplitOpenAlternate<cr>", desc = "Open alternate file in new split" },
    { "<leader>ae", "<cmd>EditProjectionsFile<cr>", desc = "Edit projections file" },
    { "<leader>ac", "<cmd>CreateProjectionsFile<cr>", desc = "Create projections file" },
  },
  projections_file = ".protestions.json",
})
```

You can modify the keys table to set your preferred key bindings.

## Commands
This plugin registers the commands and sets up key mappings after the plugin is initialized. Typically called after setup().
Commands:

    :CreateProjectionsFile – Creates a projections file.
    :EditProjectionsFile – Opens the projections file for editing.
    :ToggleAlternate – Switches between the alternate file.
    :SplitOpenAlternate – Opens the alternate file in a new vertical split.

## Contributing

Feel free to open issues or submit pull requests for bug fixes or new features.

