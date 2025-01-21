local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-------------------- Colorscheme -----------------------------------------------

local theme = "Gruvbox Material (Gogh)"
local scheme = wezterm.color.get_builtin_schemes()[theme]
config.color_scheme = theme

-- So we can append keys instead of writing a whole new object later
config.colors = {}

------------------------- Font -------------------------------------------------

-- Ligatures
-- { 'calt=0', 'clig=0', 'liga=0' }
-- config.harfbuzz_features = { 'calt=0' }

-- All Fira Code Stylistic Sets
-- a g i l r 0 3 4679
-- {'cv01', 'cv02', 'cv03-06', 'cv07-10', 'ss01', 'zero|cv11-13', 'cv14', 'onum'}
-- config.harfbuzz_features = {'cv02', 'cv03', 'cv07', 'ss01'}

-- ~ @ $ % & * () {} |
-- cv17 ss05 ss04 cv18 ss03 cv15-16 cv31 cv29 cv30
-- config.harfbuzz_features = { "ss05", "ss04", "ss03", "cv15", "cv29" }

-- <= >= <= >= == === != !== /= >>= <<= ||= |=
-- ss02 cv19-20 cv23 cv21-22 ss08 cv24 ss09
-- config.harfbuzz_features = { "ss02", "ss08", "cv24" }

-- .- :- .= [] {. .} \\ =~ !~ Fl Tl fi fj fl ft
-- cv25 cv26 cv32 cv27 cv28 ss06 ss07 s10
-- config.harfbuzz_features = { "" }

config.dpi = 144.0
config.font_size = 13.0
config.line_height = 1.1
config.display_pixel_geometry = "RGB"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_interpreter_version = 40
config.freetype_load_flags = "NO_HINTING"
config.custom_block_glyphs = true
config.anti_alias_custom_block_glyphs = true
config.use_cap_height_to_scale_fallback_fonts = true
-- config.allow_square_glyphs_to_overflow_width = "Never"

config.font_dirs = { wezterm.home_dir .. "/.local/share/fonts" }

config.font = wezterm.font_with_fallback({
  {
    family = "Hack",
    scale = 1.1,
    weight = "Bold",
  },
  {
    family = "Fira Code",
    scale = 1.1,
    weight = "Bold",
    harfbuzz_features = { "ss05", "ss04", "ss03", "cv15", "cv29", "ss02", "ss08", "cv24" }
  },
  {
    family = "Symbols Nerd Font Mono",
    scale = 1.3,
    weight = "Medium"
  },
  {
    family = "Noto Color Emoji",
    scale = 1.0
  },
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
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 15

-- Window Padding
config.window_padding = { top = 2, left = 2, right = 0, bottom = 0 }

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
config.max_fps = 120
config.animation_fps = 60
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
-- CTRL + hjkl                  Navigate panes
-- META + hjkl                  Resize panes

---------------------- Application ------------------------------
-- LEADER | CMD + Enter         Toggle fullscreen
-- LEADER | CMD + /             Searc/h
-- LEADER | CMD + b             Clear scrollback
-- LEADER | CMD + n             Spawn window
-- LEADER | CMD + q             Quit application
-- LEADER | CMD + r             Reload config
-- LEADER | CMD + c             Copy
-- LEADER | CMD + v             Paste
-- LEADER + x                   Copy mode
-- LEADER + s                   Show workspaces
-- LEADER + u                   Char select
-- LEADER + Space               Quick select
-- CMD + SHIFT + ( l | p )      Debug Overlay | Command Palette
-- CMD + ( 0 | - | = )          Reset/Decrease/Increase font size

local keymaps = require("keymaps")
config = keymaps.apply_to_config(config)

return config
