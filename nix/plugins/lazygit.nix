{ pkgs, ... }:
{
  # https://github.com/kdheepak/lazygit.nvim
  extraPlugins = [ pkgs.vimPlugins.lazygit-nvim ];

  globals = {
    lazygit_floating_window_scaling_factor = 0.9;
    lazygit_config_file_path.__raw = "os.getenv('HOME') .. '/.config/lazygit/config.yml'";
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<Cmd>LazyGit<Cr>";
      options.desc = "Toggle LazyGit";
    }
  ];
}
