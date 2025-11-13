-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Async formatting with conform, supporting ranges
vim.api.nvim_create_user_command('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format({
    async = true,
    lsp_format = 'fallback',
    range = range,
  }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), 'v') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
      end
    end
  end)
end, { range = true })

-- Disable format on save
vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.enable_autoformat = false
  else
    vim.g.enable_autoformat = false
  end
end, { desc = 'Disable autoformat-on-save', bang = true })

-- Enable format on save
vim.api.nvim_create_user_command('FormatEnable', function(args)
  if args.bang then
    -- FormatEnable! will enable formatting just for this buffer
    vim.b.enable_autoformat = true
  else
    vim.g.enable_autoformat = true
  end
end, { desc = 'Re-enable autoformat-on-save' })

-- vim: ts=2 sts=2 sw=2 et
