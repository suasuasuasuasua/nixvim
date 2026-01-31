{
  lib,
  config,
  ...
}:
let
  name = "leetcode";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/kawre/leetcode.nvim
    plugins.leetcode = {
      enable = true;
      settings = {
        lang = "cpp";
      };
    };
  };
}
