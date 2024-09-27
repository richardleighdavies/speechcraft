# SpeechCraft

SpeechCraft is an innovative text manipulation tool that leverages voice commands for streamlined text editing in Neovim.

## Features

- Voice-activated text manipulation
- Speech recognition integration
- Customizable controls
- Expandable to other text editors (future goal)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "yourusername/speechcraft",
    config = function()
        require("speechcraft").setup({
            -- Your custom options here
        })
    end,
}
```

## Usage

1. Highlight the text you want to manipulate.
2. Press and hold the activation key (default: Ctrl+S).
3. Speak your command.
4. Release the key to execute the command.

## Configuration

```lua
require("speechcraft").setup({
    activation_key = "<C-s>",
    speech_recognition_backend = "your_preferred_backend",
    custom_commands = {
        -- Add your custom commands here
    }
})
