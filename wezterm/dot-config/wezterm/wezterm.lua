local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-------------------- Colorscheme -----------------------------------------------

local theme = "Gruvbox Material (Gogh)"
-- local theme = "Gruvbox Dark (Gogh)"
local scheme = wezterm.color.get_builtin_schemes()[theme]

config.color_scheme = theme

-- So we can append keys instead of writing a whole new object later
config.colors = {}

------------------------- Font -------------------------------------------------

-- config.font_locator = "ConfigDirsOnly"
config.font_dirs = { wezterm.home_dir .. "/.local/share/fonts" }

config.font_size = 13
config.line_height = 1.1
config.use_cap_height_to_scale_fallback_fonts = true
-- config.allow_square_glyphs_to_overflow_width = 'Never'

config.font = wezterm.font_with_fallback({
  { family = "Hack", scale = 1.0 },
  { family = "Fira Code", scale = 1.0 },
  { family = "Symbols Nerd Font Mono", scale = 1.1 },
  { family = "Noto Color Emoji", scale = 1.0 },
})

------------------------- Tabs -------------------------------------------------

local tab_bar = require("tabs")
config = tab_bar.apply_to_config(config)

------------------ Windows and Panes -------------------------------------------

-- Window Configuration
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = false
config.adjust_window_size_when_changing_font_size = false

wezterm.on("gui-startup", function(cmd)
  ---@diagnostic disable-next-line: unused-local
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(2560, 0)
  window:gui_window():set_inner_size(5120, 3240)
end)

-- Window Opacity
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30

-- Window Padding
config.window_padding = { top = 2, left = 2, right = 2, bottom = 2 }

-- Dim Inactive Panes
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }

-- Pane Split Color
config.colors.split = scheme.ansi[4]

------------------------------ Misc --------------------------------------------

-- Mouse
config.swallow_mouse_click_on_pane_focus = true
config.bypass_mouse_reporting_modifiers = "ALT"

-- Cursor
---@diagnostic disable-next-line: assign-type-mismatch
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
-- config.cursor_blink_rate = 800

-- Bell
---@diagnostic disable-next-line: assign-type-mismatch
config.audible_bell = "Disabled"
config.colors.visual_bell = "#2c2d2c"
config.visual_bell = {
  fade_in_function = "Ease",
  fade_in_duration_ms = 75,
  fade_out_function = "Ease",
  fade_out_duration_ms = 75,
}

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.animation_fps = 120
config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Auto Update and Reload Config
config.check_for_updates = true
config.automatically_reload_config = true

-- Charselect
config.char_select_font_size = 15
config.char_select_bg_color = "#282828"
config.char_select_fg_color = "#ebdbb2"

-- Command Palette
config.command_palette_font_size = 15
config.command_palette_bg_color = "#282828"
config.command_palette_fg_color = "#ebdbb2"

------------------------------ Key Mappings ------------------------------------

-- CTRL + ;                     Leader

------------------------ Tabs -----------------------------------
-- LEADER | CMD + t             New tab
-- LEADER | CMD + w             Close tab
-- LEADER | CMD + ( 1-9 )       Activate a tab
-- CMD + SHIFT + ( ] | [ )      Previous/Next tab

------------------------ Panes ----------------------------------
-- LEADER + z                   Toggle pane zoom
-- LEADER + d | e               Split pane horizontal | vertical
-- LEADER + hjkl                Navigate panes
-- LEADER + CTRL + hjkl         Resize panes

---------------------- Application ------------------------------
-- LEADER | CMD + Enter         Toggle fullscreen
-- LEADER | CMD + /             Searc/h
-- LEADER | CMD + k             Clear scrollback
-- LEADER | CMD + n             Spawn window
-- LEADER | CMD + q             Quit application
-- LEADER | CMD + r             Reload config
-- LEADER | CMD + c             Copy
-- LEADER | CMD + v             Paste
-- LEADER + x                   Copy mode
-- LEADER + s                   Show workspaces
-- LEADER + Space               Quick select
-- CMD + SHIFT +  u             Char select
-- CMD + SHIFT + ( l | p )      Debug Overlay | Command Palette
-- CMD + ( 0 | - | = )          Reset/Decrease/Increase font size

config.disable_default_key_bindings = true
config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 1000 }

local keymaps = require("keymaps")
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables

return config
