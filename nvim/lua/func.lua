function strip_trailing_whitespace()
  -- 保存当前缓冲区和窗口信息
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  -- 遍历所有已加载的缓冲区
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'modifiable') then
      -- 执行替换操作：删除行尾空格（不自动保存）
      vim.api.nvim_buf_call(buf, function()
        -- 仅清除空格，不判断是否修改，也不执行保存
        vim.cmd([[keeppatterns %s/\s\+$//e]])
      end)
    end
  end

  -- 恢复之前的缓冲区和窗口
  vim.api.nvim_set_current_win(current_win)
  vim.api.nvim_set_current_buf(current_buf)
end

