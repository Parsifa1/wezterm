---@diagnostic disable: unused-local, redefined-local, undefined-field
local wezterm = require("wezterm")
local style = require("lua.style")
local keymap = require("lua.keymap")
local domains = require("lua.domains")
local config = wezterm.config_builder()

style.apply(config)
keymap.apply(config)
domains.apply(config)

-- set initial size for screens
config.initial_rows = 42
config.initial_cols = 170
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- config of tab bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_tab_bar = true
config.default_cursor_style = "BlinkingBlock"

-- set transparent
-- config.window_background_opacity = 0.83
config.win32_system_backdrop = "Acrylic" -- "Auto" or "Acrylic"
config.color_scheme = "Gruvbox Material (Gogh)"
config.animation_fps = 144
config.default_domain = "local"

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- set front_end
    config.front_end = "OpenGL"
    config.default_prog = { "pwsh", "-NoLogo" }
end

config.max_fps = 144
config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"

return config
