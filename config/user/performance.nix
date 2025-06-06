{
  # Performance tweaks
  # https://nix-community.github.io/nixvim/performance/byteCompileLua.html
  performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
  };
}
