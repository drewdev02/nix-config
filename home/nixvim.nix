{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.gruvbox.enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      cursorline = true;
      termguicolors = true;
    };

    plugins = {
      lualine.enable = true;
      treesitter.enable = true;
      telescope.enable = true;
      oil.enable = true;
      web-devicons.enable = true;
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; # Nix LSP
          lua_ls.enable = true;
          pyright.enable = true;
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "telescope find_files";
        options.desc = "Telescope Find Files";
      }
      {
        mode = "n";
        key = "-";
        action = "<CMD>Oil<CR>";
        options.desc = "Open parent directory";
      }
    ];
  };
}
