local function parse_git_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
      line = line:gsub('/$', '')
      ret[line] = true
    end
  end
  return ret
end

local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, { cwd = key, text = true })
      local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, { cwd = key, text = true })
      local ret = {
        ignored = parse_git_output(ignore_proc),
        tracked = parse_git_output(tracked_proc),
      }
      rawset(self, key, ret)
      return ret
    end,
  })
end
local git_status = new_git_status()

local show_all = false
local filter_show = function(_) return true end
local filter_git = function(fs_entry)
  local dir = vim.fs.dirname(fs_entry.path)
  local is_dotfile = vim.startswith(fs_entry.name, '.') and fs_entry.name ~= '..'
  if is_dotfile then
    return git_status[dir].tracked[fs_entry.name] == true
  else
    return not git_status[dir].ignored[fs_entry.name]
  end
end

require('mini.files').setup {
  options = { use_as_default_explorer = false },
  content = { filter = filter_git },
}

local toggle_dotfiles = function()
  show_all = not show_all
  local new_filter = show_all and filter_show or filter_git
  MiniFiles.refresh { content = { filter = new_filter } }
end
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args) vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = args.data.buf_id }) end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  callback = function() git_status = new_git_status() end,
})

vim.keymap.set('n', '-', function()
  local path = vim.api.nvim_buf_get_name(0)
  MiniFiles.open(path ~= '' and path or vim.fn.getcwd())
end, { desc = 'Open parent directory' })
