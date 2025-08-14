-- [[ Colorscheme ]]

-- vim.g.tinted_shell_path = vim.env.HOME .. '/.local/share/tinted-theming/tinty/repos/tinted-shell/scripts'
-- vim.g.tinted_colorspace = 256
-- vim.cmd.colorscheme('base24-gruvbox-dark-medium')

-- local theme_script_path = vim.fn.expand(vim.env.HOME .. "/.local/share/tinted-theming/tinty/tinted-vim-colors-file.vim")
--
-- local function file_exists(file_path)
--   return vim.fn.filereadable(file_path) == 1 and true or false
-- end
--
-- local function handle_focus_gained()
--   if file_exists(theme_script_path) then
--       vim.cmd("source " .. theme_script_path)
--   end
-- end
--
-- if file_exists(theme_script_path) then
--   vim.o.termguicolors = true
--   vim.g.tinted_colorspace = 256
--
--   vim.cmd("source " .. theme_script_path)
--
--   vim.api.nvim_create_autocmd("FocusGained", {
--     callback = handle_focus_gained,
--   })
-- end

vim.g.tinted_colorspace = 256
vim.cmd.colorscheme('onedark')

-- vim: ts=2 sts=2 sw=2 et
