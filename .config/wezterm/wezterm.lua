local wezterm = require("wezterm")
local config = {}

local dark_theme = true
local ok, mod = pcall(require, "terminal_colorscheme")
if ok then
    dark_theme = mod.dark_mode()
end

-- basic appearance
local color_scheme_name = dark_theme and "Catppuccin Macchiato" or "Catppuccin Latte"
-- make sure the color scheme exists
local color_scheme = wezterm.get_builtin_color_schemes()[color_scheme_name]

if color_scheme ~= nil then
    config.color_scheme = color_scheme_name
    if dark_theme then
        config.colors = { background = "#282828" }
    end

    config.color_schemes = { [color_scheme_name] = color_scheme }
else
    error("Color scheme '" .. color_scheme_name .. "' not found")
end

config.enable_wayland = false -- temporarily, run under xwayland instead
config.font = wezterm.font_with_fallback({
    "Source Code Pro",
    "Symbols Nerd Font Mono",
})
config.font_size = 16.0
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true

-- bell
config.visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 50,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 50,
}
config.audible_bell = "Disabled"

-- scrollback
config.scrollback_lines = 1000000

-- keybinds
config.keys = {
    -- clipboard
    {
        key = "c",
        mods = "SHIFT|ALT",
        action = wezterm.action({ CopyTo = "Clipboard" }),
    },
    {
        key = "v",
        mods = "SHIFT|ALT",
        action = wezterm.action({ PasteFrom = "Clipboard" }),
    }, -- scrollback
    {
        key = "PageUp",
        mods = "SHIFT",
        action = wezterm.action({ ScrollByPage = -1 }),
    },
    {
        key = "PageDown",
        mods = "SHIFT",
        action = wezterm.action({ ScrollByPage = 1 }),
    }, -- create new tab
    {
        key = "t",
        mods = "SHIFT|ALT",
        action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
    }, -- swap panes using vim keys
    {
        key = "j",
        mods = "SHIFT|ALT",
        action = wezterm.action({ ActivatePaneDirection = "Down" }),
    },
    {
        key = "k",
        mods = "SHIFT|ALT",
        action = wezterm.action({ ActivatePaneDirection = "Up" }),
    },
    {
        key = "h",
        mods = "SHIFT|ALT",
        action = wezterm.action({ ActivatePaneDirection = "Left" }),
    },
    {
        key = "l",
        mods = "SHIFT|ALT",
        action = wezterm.action({ ActivatePaneDirection = "Right" }),
    }, -- disable the alt+enter keybind to make fullscreen
    { key = "Enter", mods = "ALT", action = "DisableDefaultAssignment" },
}

return config
