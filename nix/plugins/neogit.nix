{
  # https://github.com/NeogitOrg/neogit/
  plugins.neogit.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<Leader>gg";
      action = "<CMD>Neogit<CR>";
      options.desc = "Show Neogit UI";
    }
  ];
}
