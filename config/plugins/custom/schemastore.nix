{
  lib,
  config,
  ...
}:
let
  name = "schemastore";
  cfg = config.suasuasuasuasua.nixvim.plugins.${name};
in
{
  options.suasuasuasuasua.nixvim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/b0o/SchemaStore.nvim/
    plugins.schemastore = {
      enable = true;

      # added to jsonls
      json = {
        enable = true;
        # require('schemastore').json.schemas
        settings = { };
      };
      # added to yamlls
      yaml = {
        enable = true;
        # require('schemastore').yaml.schemas
        settings = { };
      };
    };
  };
}
