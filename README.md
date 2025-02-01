# altestnate.nvim

**altestnate.nvim** is a Neovim plugin for easy navigation between test and source files with configurable key mappings. It integrates with Neovim's built-in user commands and allows you to quickly toggle between alternate files, open them in new splits, and manage projection files.

## Features

- **Toggle between alternate test files** (e.g., from `.ts` to `.test.ts`, from `.lua` to `_spec.lua`).
- **Open alternate test files in a vertical split** for better side-by-side editing.
- **Edit and create projection files** for better management of your alternate file mappings.
- **Customizable key mappings** for easy access.

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
      { "<leader>ae", "<cmd>EditProjectionFile<cr>", desc = "Edit the projection file" },
      { "<leader>ac", "<cmd>CreateProjectionsFile<cr>", desc = "Create a projection file" },
    },
  },
}
```
## Usage
### Key Mappings

By default, the plugin provides the following key mappings:

    <leader>at: Toggle between the alternate file.
    <leader>as: Open the alternate file in a vertical split.
    <leader>ae: Edit the projection file.
    <leader>ac: Create a projection file.

You can customize these key mappings by modifying the opts in the plugin setup.
Commands

    :ToggleAlternate – Toggle between the alternate file.
    :SplitOpenAlternate – Open the alternate file in a vertical split.
    :EditProjectionFile – Edit the projection file.
    :CreateProjectionsFile – Create a projection file.

## Setup & Configuration

To configure the plugin, simply call the setup() function within your init.lua or config.lua:

```lua
require("altestnate").setup({
  keys = {
    { "<leader>at", "<cmd>ToggleAlternate<cr>", desc = "Toggle alternate file" },
    { "<leader>as", "<cmd>SplitOpenAlternate<cr>", desc = "Open alternate file in new split" },
    { "<leader>ae", "<cmd>EditProjectionFile<cr>", desc = "Edit projection file" },
    { "<leader>ac", "<cmd>CreateProjectionsFile<cr>", desc = "Create projection file" },
  },
})
```

You can modify the keys table to set your preferred key bindings.

## Commands
This plugin registers the commands and sets up key mappings after the plugin is initialized. Typically called after setup().
Commands:

    :CreateProjectionsFile – Creates a projection file.
    :EditProjectionFile – Opens the projection file for editing.
    :ToggleAlternate – Switches between the alternate file.
    :SplitOpenAlternate – Opens the alternate file in a new vertical split.

## Contributing

Feel free to open issues or submit pull requests for bug fixes or new features.
