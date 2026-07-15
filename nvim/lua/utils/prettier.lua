local M = {}
function M.has_config(path)
  vim.fn.system({ 'prettier', '--find-config-path', path })
  return vim.v.shell_error == 0
end

return M
