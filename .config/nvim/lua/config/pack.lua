-- vim.pack helpers/commands

vim.api.nvim_create_user_command('PluginUpdate', function()
  vim.pack.update()
end, { desc = 'Update vim.pack managed plugins' })

vim.api.nvim_create_user_command('PluginInstall', function()
  -- Sync plugins to the lockfile (installs missing plugins as needed).
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = 'Install/sync vim.pack managed plugins' })

vim.api.nvim_create_user_command('PluginClean', function()
  local names = vim.iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable()

  if #names == 0 then
    vim.notify('vim.pack: no inactive plugins to delete')
    return
  end

  vim.pack.del(names)
  vim.notify('vim.pack: deleted ' .. table.concat(names, ', '))
end, { desc = 'Delete vim.pack plugins not in config' })
