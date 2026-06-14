{
  autoCmd = [
    {
      event = "FileType";
      pattern = "cpp";
      callback.__raw =
        # lua
        ''
          function()
            vim.keymap.set('n', '<M-o>', '<Cmd>LspClangdSwitchSourceHeader<CR>',
              { buffer = true, desc = 'Switch between the header and source file' })
          end
        '';
    }
  ];
}
