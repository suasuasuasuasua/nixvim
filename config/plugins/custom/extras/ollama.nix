{
  lib,
  config,
  ...
}:
let
  name = "ollama";
  cfg = config.nixvim.plugins.custom.${name};
in
{
  options.nixvim.plugins.custom.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/nomnivore/ollama.nvim
    plugins.ollama = {
      enable = true;
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
          "x"
          "s"
        ];
        key = "<leader>oo";
        action = "<cmd>Ollama<cr>";
        options = {
          desc = "Open Ollama context menu";
        };
      }
      {
        mode = "n";
        key = "<leader>om";
        action = "<cmd>OllamaModel<cr>";
        options = {
          desc = "Choose Ollama Model";
        };
      }
      {
        mode = "n";
        key = "<leader>os";
        action = "<cmd>OllamaServe<cr>";
        options = {
          desc = "Ollama Serve";
        };
      }
      {
        mode = "n";
        key = "<leader>op";
        action = "<cmd>OllamaServeStop<cr>";
        options = {
          desc = "Stop Ollama Serve";
        };
      }
    ];
  };
}
