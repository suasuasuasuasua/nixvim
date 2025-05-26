{
  lib,
  config,
  ...
}:
let
  name = "mini";
  cfg = config.nixvim.plugins.kickstart.${name};
in
{
  options.nixvim.plugins.kickstart.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # Collection of various small independent plugins/modules
    # https://nix-community.github.io/nixvim/plugins/mini.html
    plugins.mini = {
      enable = true;

      modules = {
        # better around/inside textobjects (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md)
        #
        # Examples:
        #  - va)  - [V]isually select [A]round [)]paren
        #  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        #  - ci'  - [C]hange [I]nside [']quote
        ai = {
          n_lines = 500;
        };

        # gS to split and join (https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-splitjoin.md)
        splitjoin = { };

        # starter = {
        #   content_hooks = {
        #     "__unkeyed-1.adding_bullet" = {
        #       __raw = "require('mini.starter').gen_hook.adding_bullet()";
        #     };
        #     "__unkeyed-2.indexing" = {
        #       __raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
        #     };
        #     "__unkeyed-3.padding" = {
        #       __raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
        #     };
        #   };
        #   evaluate_single = true;
        #   header = ''
        #     ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
        #     ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
        #     ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
        #     ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
        #     ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
        #   '';
        #   items = {
        #     "__unkeyed-1.buildtin_actions" = {
        #       __raw = "require('mini.starter').sections.builtin_actions()";
        #     };
        #     "__unkeyed-2.recent_files_current_directory" = {
        #       __raw = "require('mini.starter').sections.recent_files(10, true)";
        #     };
        #     "__unkeyed-3.recent_files" = {
        #       __raw = "require('mini.starter').sections.recent_files(10, false)";
        #     };
        #     "__unkeyed-4.sessions" = {
        #       __raw = "require('mini.starter').sections.sessions(5, true)";
        #     };
        #   };
        # };

        # ... and there is more!
        # Check out: https://github.com/echasnovski/mini.nvim
      };
    };
  };
}
