{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "obsidian";
  cfg = config.nixvim.plugins.${name};
in
{
  options.nixvim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
    workspaces = lib.mkOption {
      type =
        with lib.types;
        listOf (
          types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "The name for this workspace";
              };

              path = lib.mkOption {
                type = lib.types.path;
                description = "The path of the workspace.";
              };
            };
          }
        );
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/epwalsh/obsidian.nvim
    plugins.obsidian = {
      enable = true;

      package = pkgs.vimPlugins.obsidian-nvim.overrideAttrs {
        # https://github.com/obsidian-nvim/obsidian.nvim/issues/164
        src = pkgs.fetchFromGitHub {
          owner = "obsidian-nvim";
          repo = "obsidian.nvim";
          rev = "obsidian_open_refactor";
          hash = "sha256-RLh+D86+kn7mr70VLg8Z0l6fYg52/WfRDn4C3Q5xrhA=";
        };
      };

      settings = {
        inherit (cfg) workspaces;

        open.func.__raw =
          lib.mkIf pkgs.stdenv.isDarwin
            # lua
            ''
              function(uri)
                -- NOTE: the trampoline path doesn't work for some reason
                vim.ui.open(uri, { cmd = { "open", "-a", "${pkgs.obsidian}/Applications/Obsidian.app" } })
              end
            '';

        notes_subdir = "01-fleeting";

        # see below for full list of options 👇
        daily_notes = {
          # Optional, if you keep daily notes in a separate directory.
          folder = "00-dailies";
          # Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d";
          # Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y";
          # Optional, default tags to add to each new daily note created.
          default_tags = [ "daily-notes" ];
          # Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = null;
        };

        # Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        completion = {
          # Enables completion using nvim_cmp
          nvim_cmp = false;
          # Enables completion using blink.cmp
          blink = true;
          # Trigger completion at 2 chars.
          min_chars = 2;
        };

        templates = {
          folder = "templates";
          date_format = "%Y-%m-%d-%a";
          time_format = "%H:%M";
        };

        # Disable all the mappings
        mappings = null;

        # Where to put new notes. Valid options are
        # * "current_dir" - put new notes in same directory as the current
        # buffer.
        # * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir";

        note_id_func =
          # lua
          ''
            function(title)
              local suffix = ""
              if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
              else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                  suffix = suffix .. string.char(math.random(65, 90))
                end
              end

              return tostring(os.date "%Y-%m-%dT%H-%M-%S") .. "_" .. suffix
             end
          '';

        # Disable the UI rendering for obsidian
        ui.enable = false;
      };

      lazyLoad = {
        enable = true;

        settings = {
          event = [ "DeferredUIEnter" ];
          keys = [
            {
              __unkeyed-1 = "<leader>so";
              __unkeyed-3 = "<CMD>Obsidian<CR>";
              mode = "n";
              desc = "[S]earch [O]bsidian";
            }
          ];
        };
      };
    };

    # add the sources to blink
    plugins.blink-cmp.settings.sources.default = [
      "obsidian"
      "obsidian_new"
      "obsidian_tags"
    ];

    extraPackages =
      let
        inherit (lib) optionals;
        inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
      in
      with pkgs;
      [ ripgrep ]
      ++ optionals isDarwin [
        pngpaste # macOS
      ]
      ++ optionals isLinux [
        xclip # x11
        wl-clipboard # wayland
        wsl-open # for wsl users
      ];
  };
}
