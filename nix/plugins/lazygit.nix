{
  plugins.lazygit = {
    enable = true;
    settings = {
      floating_window_scaling_factor = 0.9;
      use_custom_config_file_path = 1;
      config_file_path.__raw = "vim.fn.expand '$HOME' .. '/.config/lazygit/config.yml'";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<Cmd>LazyGit<CR>";
      options.desc = "Toggle LazyGit";
    }
  ];
}
