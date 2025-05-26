{ lib, config, ... }:
{
  plugins = {
    blink-cmp = {
      enable = true;

      settings = {
        # 'default' (recommended) for mappings similar to built-in completions
        # <c-y> to accept ([y]es) the completion.
        # This will auto-import if your LSP supports it.
        # This will expand snippets if the LSP sent a snippet.
        # 'super-tab' for tab to accept
        # 'enter' for enter to accept
        # 'none' for no mappings
        #
        # For an understanding of why the 'default' preset is recommended,
        # you will need to read `:help ins-completion`
        #
        # No, but seriously. Please read `:help ins-completion`, it is really
        # good!
        #
        # All presets have the following mappings:
        # <tab>/<s-tab>: move to right/left of your snippet expansion
        # <c-space>: Open menu or open docs if already open
        # <c-n>/<c-p> or <up>/<down>: Select next/previous item
        # <c-e>: Hide menu
        # <c-k>: Toggle signature help
        #
        # See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = "default";
        };
        appearance = {
          # 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          # Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono";
        };
        completion = {
          # By default, you may press `<c-space>` to show the documentation.
          # Optionally, set `auto_show = true` to show the documentation after
          # a delay.
          documentation = {
            auto_show = false;
            auto_show_delay_ms = 500;
          };
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "emoji"
            "git"
            # "ripgrep"
          ];
          providers = {
            # TODO: the pop-up for blink-emoji is _really_ slow for some
            # reason
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 5;
              # Optional configurations
              opts = {
                insert = true;
              };
              should_show_items.__raw =
                # lua
                ''
                  function()
                    return vim.tbl_contains(
                      -- Enable emoji completion only for git commits and markdown.
                      -- By default, enabled for all file-types.
                      { "gitcommit", "markdown" },
                      vim.o.filetype
                    )
                  end
                '';
            };
            git = {
              module = "blink-cmp-git";
              name = "git";
              # -- only enable this source when filetype is gitcommit, markdown, or 'octo'
              enabled.__raw =
                # lua
                ''
                  function()
                    return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
                  end
                '';
              score_offset = 10;
              opts = {
                commit = { };
                git_centers = {
                  git_hub = { };
                };
              };
            };
            # ripgrep = {
            #   async = true;
            #   module = "blink-ripgrep";
            #   name = "Ripgrep";
            #   score_offset = 0;
            #   opts = {
            #     prefix_min_len = 3;
            #     context_size = 5;
            #     max_filesize = "1M";
            #     project_root_marker = ".git";
            #     project_root_fallback = true;
            #     search_casing = "--ignore-case";
            #     additional_rg_options = { };
            #     fallback_to_regex_highlighting = true;
            #     ignore_paths = { };
            #     additional_paths = { };
            #     debug = false;
            #   };
            # };
          };
        };
        snippets = {
          preset = "luasnip";
        };
        # Blink.cmp includes an optional, recommended rust fuzzy matcher,
        # which automatically downloads a prebuilt binary when enabled.
        #
        # By default, we use the Lua implementation instead, but you may enable
        # the rust implementation via `'prefer_rust_with_warning'`
        #
        # See :h blink-cmp-config-fuzzy for more information
        fuzzy = {
          implementation = "prefer_rust_with_warning";
        };
        # Shows a signature help window while you type arguments for a function
        signature = {
          enabled = true;
        };
      };

      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [ "InsertEnter" ];
        };
      };
    };

    # Completion sources
    blink-emoji.enable = true;
    blink-cmp-git.enable = true;
    # blink-ripgrep.enable = true;

    # Dependencies
    #
    # Snippet Engine & its associated nvim-cmp source
    # https://nix-community.github.io/nixvim/plugins/luasnip/index.html
    luasnip = {
      enable = true;
      # setup for friendly snippets
      fromVscode = [
        { }
      ];
      lazyLoad = lib.mkIf config.plugins.lz-n.enable {
        enable = true;
        settings = {
          event = [ "InsertEnter" ];
          priority = 55; # default=50, load before blink
        };
      };
    };

    # `friendly-snippets` contains a variety of premade snippets
    #    See the README about individual language/framework/plugin snippets:
    #    https://github.com/rafamadriz/friendly-snippets
    # https://nix-community.github.io/nixvim/plugins/friendly-snippets.html
    friendly-snippets = {
      enable = true;
    };
  };
}
