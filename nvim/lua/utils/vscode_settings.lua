local M = {}

--- 读取并解析 .vscode/settings.json 文件
--- @return table|boolean 返回解析后的配置或false
function M.read_vscode_settings()
  -- 获取当前工作目录
  local cwd = Snacks.git.get_root()

  if not cwd then
    return false
  end

  local settings_path = cwd .. '/.vscode/settings.json'
  -- 检查文件是否存在
  if vim.fn.filereadable(settings_path) == 0 then
    return false
  end

  -- 读取文件内容
  local content = vim.fn.readfile(settings_path)
  local json_str = table.concat(content, '\n')

  -- 尝试解析 JSON
  local ok, json_data = pcall(vim.fn.json_decode, json_str)
  if not ok then
    -- 如果解析失败，尝试移除注释（简单的处理）
    json_str = json_str:gsub('//[^\n]*', ''):gsub('/%*.-%*/', '')
    ok, json_data = pcall(vim.fn.json_decode, json_str)

    if not ok then
      vim.notify('Failed to parse .vscode/settings.json', vim.log.levels.WARN)
      return false
    end
  end

  -- 检查 eslint.validate 是否存在，如果不存在则返回 false
  if json_data['eslint.validate'] == nil then
    return false
  end

  -- 构建返回结果
  local result = {
    prettierEnable = false,
    eslintRulesCustomizations = {},
    eslintValidate = {},
  }

  -- 提取 prettier.enable 值
  if json_data['prettier.enable'] ~= nil then
    result.prettierEnable = json_data['prettier.enable']
  end

  -- 定义默认的 eslintRulesCustomizations
  local default_customizations = {
    { rule = 'style/*', severity = 'on', fixable = true },
    { rule = 'format/*', severity = 'on', fixable = true },
    { rule = '*-indent', severity = 'on', fixable = true },
    { rule = '*-spacing', severity = 'on', fixable = true },
    { rule = '*-spaces', severity = 'on', fixable = true },
    { rule = '*-order', severity = 'on', fixable = true },
    { rule = '*-dangle', severity = 'on', fixable = true },
    { rule = '*-newline', severity = 'on', fixable = true },
    { rule = '*quotes', severity = 'on', fixable = true },
    { rule = '*semi', severity = 'on', fixable = true },
  }

  -- 提取 eslint.rules.customizations
  if json_data['eslint.rules.customizations'] ~= nil then
    local customizations = json_data['eslint.rules.customizations']
    -- 检查 customizations 是否为空
    if #customizations > 0 then
      for _, item in ipairs(customizations) do
        local rule_item = {
          rule = item.rule or '',
          severity = item.severity or 'off',
          fixable = item.fixable or false,
        }
        table.insert(result.eslintRulesCustomizations, rule_item)
      end
    else
      -- 如果为空，使用默认值
      result.eslintRulesCustomizations = default_customizations
    end
  else
    -- 如果未定义，使用默认值
    result.eslintRulesCustomizations = default_customizations
  end

  -- 提取 eslint.validate
  if json_data['eslint.validate'] ~= nil then
    local validate_list = json_data['eslint.validate']
    for _, lang in ipairs(validate_list) do
      table.insert(result.eslintValidate, lang)
    end
  end

  return result
end

return M
