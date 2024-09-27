# SpeechCraft

SpeechCraft is an innovative Neovim plugin that enables voice-activated text manipulation, bringing a new dimension to your editing experience.

## Features

- **Voice-Activated Commands**: Perform text operations using spoken commands.
- **Intuitive Interface**: Seamlessly integrates with Neovim's workflow.
- **Customizable Panel**: A dedicated panel for displaying information and feedback.
- **Markdown Support**: Built-in rendering of markdown content in the panel.
- **Extensible Architecture**: Easily add custom voice commands to suit your needs.

## Requirements

- Neovim 0.7.0 or higher

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "richarddavies/speechcraft",
    config = function()
        require("speechcraft").setup({
            -- Your custom options here
        })
    end,
}
```

## Configuration

Configure SpeechCraft in your `init.lua`:

```lua
require("speechcraft").setup({
    activation_key = "<C-s>",
    speech_recognition_backend = "your_preferred_backend",
    custom_commands = {
        -- Add your custom commands here
    },
    panel_width = 0.25,  -- 25% of the screen width
    markdown_renderer = "native"  -- Default to Treesitter (native) rendering
})
```

## Usage

1. Highlight the text you want to manipulate.
2. Press and hold the activation key (default: `<C-s>`).
3. Speak your command.
4. Release the key to execute the command.

## Available Commands

- "Delete"
- "Copy"
- "Replace with [your text]"
- "Comment out"

## Key Mappings

- `<leader>sd`: Toggle SpeechCraft panel visibility
- `<leader>se`: Enable SpeechCraft panel window
- `<leader>sx`: Disable SpeechCraft panel window
- `<leader>sf`: Focus on SpeechCraft panel content section
- `<leader>sp`: Return focus to the previous window
- `<leader>st`: Toggle focus on SpeechCraft panel content
- `<leader>sm`: Load markdown into SpeechCraft panel

## Custom Commands

You can add custom voice commands by modifying the `custom_commands` table in the setup function.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
