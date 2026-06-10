{
  # return {
  #   settings = {
  #     formatterMode = "typstyle", -- or "typstfmt"
  #     formatterProseWrap = true,  -- wrap lines in content mode
  #     formatterPrintWidth = 80,   -- limit line length to 80 if possible
  #     formatterIndentSize = 2,    -- indentation width
  #   }
  # }
  plugins.lsp.servers.tinymist.settings = {
    formatterMode = "typstyle";
    formatterProseWrap = true;
    formatterPrintWidth = 80;
    formatterIndentSize = 2;
  };
}
