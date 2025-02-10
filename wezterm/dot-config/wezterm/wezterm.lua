--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.set_environment_variables = {
  PATH = "/opt/homebrew/bin:" .. wezterm.home_dir .. "/.local/bin" .. os.getenv("PATH"),
}

-------------------- Colorscheme -----------------------------------------------

-- Builtin
-- wezterm.GLOBAL.theme = "Espresso (base16)"

-- wezterm.GLOBAL.theme = "Catppuccin Mocha"
-- wezterm.GLOBAL.theme = "Catppuccin Macchiato"
-- wezterm.GLOBAL.theme = "Catppuccin Frappe"

wezterm.GLOBAL.theme = "Gruvbox Material (Gogh)"
-- wezterm.GLOBAL.theme = "Gruvbox Dark (Gogh)"
-- wezterm.GLOBAL.theme = "Gruvbox dark, hard (base16)"
-- wezterm.GLOBAL.theme = "Gruvbox dark, medium (base16)"
-- wezterm.GLOBAL.theme = "Gruvbox dark, soft (base16)"
-- wezterm.GLOBAL.theme = "Gruvbox dark, pale (base16)"
-- wezterm.GLOBAL.theme = "GruvboxDark"
-- wezterm.GLOBAL.theme = "GruvboxDarkHard"

-- Load Scheme Here
wezterm.GLOBAL.scheme = wezterm.color.get_builtin_schemes()[wezterm.GLOBAL.theme]

--- Custom
-- wezterm.GLOBAL.theme = 'GruvboxDarkHardMaterial'
-- wezterm.GLOBAL.theme = 'GruvboxDarkHardOrig'
-- wezterm.GLOBAL.theme = 'GruvboxDarkHardMix'
-- wezterm.GLOBAL.theme = 'GruvboxDarkMediumMaterial'
-- wezterm.GLOBAL.theme = 'GruvboxDarkMediumOrig'
-- wezterm.GLOBAL.theme = "GruvboxDarkMediumMix"

-- Load Scheme Here
-- wezterm.GLOBAL.scheme = wezterm.color.load_scheme( wezterm.config_dir .. "/colors/" .. wezterm.GLOBAL.theme .. ".toml")

-- Enable Theme Here
config.color_scheme = wezterm.GLOBAL.theme

if wezterm.GLOBAL.scheme == nil then
  wezterm.GLOBAL.scheme = wezterm.color.get_default_colors()
end

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

config.dpi = 140.0
config.font_size = 14.0
config.line_height = 1.2
config.display_pixel_geometry = "RGB"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_interpreter_version = 40
config.freetype_load_flags = "NO_HINTING"
config.custom_block_glyphs = true
config.anti_alias_custom_block_glyphs = true
config.use_cap_height_to_scale_fallback_fonts = true
---@diagnostic disable-next-line: assign-type-mismatch
config.allow_square_glyphs_to_overflow_width = "Always"

config.font_dirs = { wezterm.home_dir .. "/.local/share/fonts" }

config.font = wezterm.font_with_fallback({
  {
    family = "Hack",
    scale = 1.0,
    weight = "Medium",
  },
  {
    family = "Fira Code",
    scale = 1.0,
    weight = "Medium",
    harfbuzz_features = { "ss05", "ss04", "ss03", "cv15", "cv29", "ss02", "ss08", "cv24" },
  },
  {
    family = "Symbols Nerd Font Mono",
    scale = 1.0,
    weight = "Regular",
  },
  {
    family = "Noto Color Emoji",
    scale = 1.0,
  },
})

------------------------- Tabs -------------------------------------------------

-- local tab_bar = require("tabs")
-- tab_bar.apply_to_config(config)
config.tab_max_width = 32
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.status_update_interval = 500
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = false
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    tabs_enabled = true,
    theme = wezterm.GLOBAL.theme,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    tabline_a = {
      { "mode", padding = 1 },
    },
    tabline_b = {
      { "hostname", padding = 1, icon = wezterm.nerdfonts.fa_desktop },
      { "workspace", padding = 1 },
    },
    tabline_c = { "" },
    tab_active = {
      { "zoomed", padding = 1 },
      { "output", padding = 1 },
      -- " .../",
      -- { "cwd", padding = 0 },
      { "process", padding = 1 },
    },
    tab_inactive = {
      { "output", padding = 2 },
      { "process", padding = 2 },
    },
    tabline_x = { "" },
    tabline_y = { "ram", "cpu", "battery" },
    tabline_z = { "datetime" },
  },
  extensions = {},
})

-- print(tabline.get_colors())
------------------ Windows and Panes -------------------------------------------

wezterm.on("gui-startup", function(cmd)
  ---@diagnostic disable-next-line: unused-local
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(2560, 0)
  window:gui_window():set_inner_size(5120, 3240)
end)

config.initial_cols = 320
config.initial_rows = 94

-- Window Configuration
config.enable_scroll_bar = false
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = false
config.adjust_window_size_when_changing_font_size = false

-- Window Opacity
-- config.window_background_opacity = 0.95
-- config.macos_window_background_blur = 35

-- Window Padding
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }

-- Dim Inactive Panes
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }

-- Pane Split Color
config.colors.split = wezterm.GLOBAL.scheme.ansi[8]

------------------------------ Misc --------------------------------------------

-- Mouse
config.swallow_mouse_click_on_pane_focus = true
config.bypass_mouse_reporting_modifiers = "ALT"

-- Cursor
---@diagnostic disable-next-line: assign-type-mismatch
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true

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
config.max_fps = 144
config.animation_fps = 72
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- Auto Update and Reload Config
config.check_for_updates = true
config.automatically_reload_config = true

-- Charselect
config.char_select_font_size = 16
config.char_select_bg_color = "#282828"
config.char_select_fg_color = "#ebdbb2"

-- Command Palette
config.command_palette_font_size = 16
config.command_palette_bg_color = "#282828"
config.command_palette_fg_color = "#ebdbb2"

------------------------------ Key Mappings ------------------------------------

-- CTRL + ;                     Leader

------------------------ Tabs -----------------------------------
-- CMD + t                      New tab
-- CMD + w                      Close tab
-- CMD + 1-9                    Activate a tab
-- CMD + SHIFT + ] | [          Previous/Next tab

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
-- CMD + SHIFT + l | p          Debug Overlay | Command Palette
-- CMD + 0 | - | =              Reset/Decrease/Increase font size

local keymaps = require("keymaps")
keymaps.apply_to_config(config)

return config
