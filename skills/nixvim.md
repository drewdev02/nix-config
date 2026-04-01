# Nixvim Skill - Guía Completa

## ¿Qué es Nixvim?

Nixvim es una distribución de Neovim construida alrededor de módulos de Nix. Se distribuye como un flake de Nix y se configura mediante Nix, permitiendo configurar Neovim completamente usando expresiones Nix mientras genera configuración Lua para carga rápida.

## Instalación

### Con Flakes (Recomendado)

```nix
{
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    # Para stable: url = "github:nix-community/nixvim/nixos-25.11";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, nixvim, ... }: {
    # outputs...
  };
}
```

### Import Directo

```nix
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # ref = "nixos-25.11" para stable
  });
in
# configuraciones...
```

## Uso como Módulo

### Home Manager / nix-darwin / NixOS

```nix
{
  imports = [ inputs.nixvim.homeModules.nixvim ];
  
  programs.nixvim = {
    enable = true;
    # configuración...
  };
}
```

### Mejor Práctica - Usar imports

```nix
# home.nix
{
  programs.nixvim.imports = [ ./nixvim.nix ];
}

# nixvim.nix
{ lib, pkgs, ... }:
{
  # Usar lib.nixvim y configurar sin prefijo
  plugins.my-plugin.enable = true;
}
```

## Configuración Básica

### Ejemplo Mínimo

```nix
{
  programs.nixvim = {
    enable = true;
    
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
}
```

### Opciones Comunes

```nix
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    # Colorscheme
    colorscheme = "catppuccin";
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    
    # Leader key
    globals.mapleader = " ";
    globals.maplocalleader = " ";
    
    # Opciones de editor
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
      mouse = "a";
      clipboard = "unnamedplus";
    };
  };
}
```

## Plugins

### Plugins con Módulo Nativo

```nix
{
  plugins = {
    # LSP
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        lua_ls.enable = true;
        pyright.enable = true;
      };
    };
    
    # Autocompletado
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
    cmp-nvim-lsp.enable = true;
    
    # UI
    lualine.enable = true;
    treesitter.enable = true;
    telescope.enable = true;
    neo-tree.enable = true;
    
    # Utilidades
    comment.enable = true;
    oil.enable = true;
    web-devicons.enable = true;
  };
}
```

### Plugins Sin Módulo (extraPlugins)

```nix
{
  programs.nixvim = {
    # Plugin de nixpkgs
    extraPlugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      nvim-web-devicons
    ];
    
    # Configuración Lua
    extraConfigLua = ''
      require("gruvbox").setup({})
      vim.cmd.colorscheme("gruvbox")
    '';
  };
}
```

### Plugins de GitHub (no están en nixpkgs)

```nix
{
  programs.nixvim = {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "my-plugin";
      src = pkgs.fetchFromGitHub {
        owner = "owner";
        repo = "repo";
        rev = "commit-hash";
        hash = "sha256-...";
      };
    })];
    
    extraConfigLua = ''
      require('my-plugin').setup({})
    '';
  };
}
```

## Keymaps

### Keymaps Básicos

```nix
{
  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find Files";
    }
  ];
}
```

### Múltiples Keys para Misma Acción

```nix
{
  keymaps = 
    map (key: {
      inherit key;
      action = "<some-action>";
      options.desc = "My keymap";
    }) ["<key-1>" "<key-2>" "<key-3>"]
    ++ [
      # Otros keymaps...
    ];
}
```

### Modos Disponibles

- `n` - Normal
- `v` - Visual
- `i` - Insert
- `t` - Terminal
- `[ "n" "v" ]` - Múltiples modos

## Autocompletado (nvim-cmp)

```nix
{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    
    settings = {
      completion.keywordLength = 2;
      
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      
      mapping = {
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<ESC>" = "cmp.mapping.close()";
      };
    };
  };
  
  plugins.luasnip.enable = true;
  plugins.cmp_luasnip.enable = true;
}
```

## LSP

```nix
{
  plugins.lsp = {
    enable = true;
    
    # onAttach y capabilities
    onAttach = "require('cmp_nvim_lsp').on_attach()";
    capabilities = "require('cmp_nvim_lsp').default_capabilities()";
    
    # Keymaps LSP
    keymaps = {
      diagnostic = {
        "<leader>j" = "goto_next";
        "<leader>k" = "goto_prev";
      };
      lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };
    };
    
    # Servidores
    servers = {
      nil_ls = {
        enable = true;
        filetypes = [ "nix" ];
      };
      lua_ls.enable = true;
      pyright.enable = true;
      rust_analyzer.enable = true;
    };
  };
  
  plugins.lsp-format.enable = true;
}
```

## Diagnósticos

```nix
{
  diagnostics = {
    update_in_insert = true;
    underline = true;
    severity_sort = true;
    float = {
      focusable = false;
      style = "minimal";
      border = "rounded";
      source = "always";
      header = "";
      prefix = "";
    };
  };
}
```

## Treesitter

```nix
{
  plugins.treesitter = {
    enable = true;
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
    nixGrammars = true;
  };
  
  plugins.treesitter-context.enable = true;
}
```

## Telescope

```nix
{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
    };
  };
  
  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find Files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Live Grep";
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Recent Files";
    }
  ];
}
```

## GitHub Copilot

```nix
{
  plugins.copilot-lua = {
    enable = true;
    
    settings = {
      suggestion = {
        enabled = true;
        autoTrigger = true;
        keymap = {
          accept = "<M-l>";
          next = "<M-]>";
          prev = "<M-[>";
          dismiss = "<C-]>";
        };
      };
      
      panel = {
        enabled = true;
        autoRefresh = true;
        keymap = {
          open = "<M-CR>";
          accept = "<CR>";
        };
      };
      
      filetypes = {
        yaml = true;
        markdown = true;
        gitcommit = true;
      };
    };
  };
}
```

## Performance

### Combine Plugins

```nix
{
  performance = {
    combinePlugins = {
      enable = true;
      standalonePlugins = [ "plugin-a" "plugin-b" ];
    };
  };
}
```

## Problemas Comunes y Soluciones

### 1. `attribute 'vimPlugins.<name>' not found`

**Causa:** Versión incompatible de nixpkgs/nixvim

**Solución:**
```nix
# No usar follows en nixvim
inputs.nixvim = {
  url = "github:nix-community/nixvim/nixos-25.11";
  # inputs.nixpkgs.follows NO debe seguir nixpkgs
};
```

### 2. `module '<name>' not found`

**Causa:** Plugin depende de otro plugin no instalado

**Solución:** Instalar dependencias explícitamente
```nix
plugins.web-devicons.enable = true;  # Para telescope, neo-tree
plugins.cmp-nvim-lsp.enable = true;   # Para LSP completion
```

### 3. `collision between ... and ...`

**Causa:** `performance.combinePlugins.enable` con plugins conflictivos

**Solución:**
```nix
performance.combinePlugins.standalonePlugins = [ "plugin-conflictivo" ];
```

### 4. Bug #4227 - nvim-web-devicons no se carga

**Solución temporal:**
```nix
{
  # NO usar web-devicons.enable
  extraPlugins = with pkgs.vimPlugins; [ nvim-web-devicons ];
  extraConfigLua = ''
    require("nvim-web-devicons").setup({})
  '';
  
  # O desactivar plugins que lo requieren
  # telescope.enable = false;
  # neo-tree.enable = false;
}
```

### 5. Colorschemes no funcionan

**Solución:**
```nix
{
  # En lugar de colorschemes.xxx.enable
  extraPlugins = with pkgs.vimPlugins; [ catppuccin-nvim ];
  extraConfigLua = ''
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin")
  '';
}
```

## Configuración de Ejemplo Completa

```nix
{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    
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
      mouse = "a";
      clipboard = "unnamedplus";
    };
    
    plugins = {
      lualine.enable = true;
      treesitter.enable = true;
      telescope.enable = true;
      oil.enable = true;
      web-devicons.enable = true;
      comment.enable = true;
      
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
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
      };
      cmp-nvim-lsp.enable = true;
      
      copilot-lua = {
        enable = true;
        settings = {
          suggestion.enabled = true;
          panel.enabled = true;
        };
      };
    };
    
    keymaps = [
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to Definition";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find Files";
      }
    ];
  };
}
```

## Recursos

- **Documentación oficial:** https://nix-community.github.io/nixvim/
- **GitHub:** https://github.com/nix-community/nixvim
- **Configuraciones de ejemplo:** https://github.com/nix-community/nixvim/blob/main/docs/user-configs/list.toml
- **Matrix:** #nixvim:matrix.org

## Convenciones de Nixvim

1. **CamelCase para opciones:** `autoTrigger`, `autoRefresh` (NO snake_case)
2. **Usar `settings` para configuración:** `plugins.foo.settings = {}`
3. **Explícito es mejor:** Habilitar plugins dependientes manualmente
4. **No usar `follows` en nixvim:** Mantener compatibilidad con tests
5. **Version matching:** Usar rama estable de nixvim con nixpkgs estable
