require('options')
require('keymaps')
require('func')


vim.api.nvim_create_autocmd('VimLeave', {
  pattern = '*',
  callback = strip_trailing_whitespace,
  group = vim.api.nvim_create_augroup('StripTrailingWhitespace', { clear = true }),
})
