local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Gruvbox Material (Gogh)'

config.font = wezterm.font_with_fallback {
  {
    family = 'JetBrains Mono',
    weight = 'Regular',
  },
  'Symbols Nerd Font',
}

config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font {
      family = 'JetBrains Mono',
      weight = 'ExtraBold',
    },
  },
  {
    italic = true,
    font = wezterm.font {
      family = 'JetBrains Mono',
      style = 'Italic',
    },
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font {
      family = 'JetBrains Mono',
      weight = 'ExtraBold',
      style = 'Italic',
    },
  },
}
config.font_size = 12.0

config.window_decorations = "NONE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.enable_tab_bar = false

return config
