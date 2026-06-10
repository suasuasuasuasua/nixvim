{
  extraConfigLua =
    # lua
    ''
      -- Load built-in optional packages (neovim 0.12+)
      vim.cmd 'packadd nvim.difftool'
      vim.cmd 'packadd nvim.undotree'
    '';
}
