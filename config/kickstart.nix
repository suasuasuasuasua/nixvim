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

  # [[ Basic Keymaps ]]
  #  See `:help vim.keymap.set()`
  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    # Clear highlights on search when pressing <Esc> in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Disable search highlights";
    }

    # Open diagnostic quickfix list
    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "vim.diagnostic.setloclist";
      options.desc = "Open diagnostic [Q]uickfix list";
    }

    # Move focus between panes
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }

    # Make
    {
      mode = "n";
      key = "<Leader>mm";
      action = "<Cmd>make<CR>";
      options.desc = "[M]ake the project";
    }
  ];

  # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
  autoGroups = {
    kickstart-highlight-yank = {
      clear = true;
    };
  };

  # [[ Basic Autocommands ]]
  #  See `:help lua-guide-autocommands`
  # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
  autoCmd = [
    # Highlight when yanking (copying) text
    #  Try it with `yap` in normal mode
    #  See `:help vim.highlight.on_yank()`
    {
      event = [ "TextYankPost" ];
      desc = "Highlight when yanking (copying) text";
      group = "kickstart-highlight-yank";
      callback.__raw =
        # lua
        ''
          function()
            vim.hl.on_yank()
          end
        '';
    }
  ];

  # The line beneath this is called `modeline`. See `:help modeline`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
  extraConfigLuaPost =
    # lua
    ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
}
