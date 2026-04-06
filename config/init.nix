{
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
  globals = {
    # Set <space> as the leader key
    # See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";

    # Set to true if you have a Nerd Font installed and selected in the terminal
    have_nerd_font = true; # we _should_ have nerd fonts
  };

  # [[ Setting options ]]
  # See `:help vim.opt`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
  opts = {
    autoindent = true;
    breakindent = true;
    breakindentopt = "list:-1";
    colorcolumn = "80";
    complete = ".,w,b,kspell";
    completeopt = "menuone,noselect,fuzzy,nosort";
    completetimeout = 100;
    confirm = true;
    cursorline = true;
    cursorlineopt = "screenline,number";
    expandtab = true;
    foldcolumn = "1";
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
    foldnestmax = 10;
    foldtext = "";
    formatlistpat = ''^\s*[0-9\-\+\*]\+[\.\)]*\s\+'';
    formatoptions = "rqnl1j";
    ignorecase = true;
    inccommand = "split";
    incsearch = true;
    infercase = true;
    iskeyword = "@,48-57,_,192-255,-";
    linebreak = true;
    list = true;
    listchars.__raw = "{ tab = '> ', trail = '-', nbsp = '+' }";
    mouse = "a";
    mousescroll = "ver:25,hor:6";
    number = true;
    pumborder = "single";
    pumheight = 10;
    pummaxwidth = 100;
    ruler = false;
    scrolloff = 10;
    shada = "'100,<50,s10,:1000,/100,@100,h";
    shiftround = true;
    shiftwidth = 2;
    shortmess = "CFOSWaco";
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    smartindent = true;
    softtabstop = 2;
    spelloptions = "camel";
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
    swapfile = false;
    switchbuf = "usetab";
    tabstop = 2;
    timeoutlen = 300;
    undofile = true;
    updatetime = 250;
    virtualedit = "block";
    winborder = "single";
    wrap = false;
  };

  extraConfigLua =
    # lua
    ''
      vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir'
    '';

  # The line beneath this is called `modeline`. See `:help modeline`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
  extraConfigLuaPost =
    # lua
    ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
}
