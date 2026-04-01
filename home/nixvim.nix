{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    globals.mapleader = " ";

    # Opciones de NVim
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

    # Plugins manuales (evitan bugs de los módulos)
    extraPlugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      lualine-nvim
      oil-nvim
      nvim-comment
      # Neo-tree (sidebar tipo VSCode)
      neo-tree-nvim
      nui-nvim
      nvim-web-devicons
      # Tabs/buffers estilo IDE
      bufferline-nvim
      # Terminal toggle
      toggleterm-nvim
      # GitHub Copilot
      copilot-lua
      # Diagnostics panel estilo VSCode Problems
      trouble-nvim
      # 1. Git - cambios en el margen
      gitsigns-nvim
      # 2. Búsqueda - fuzzy finder tipo Ctrl+P
      telescope-nvim
      # 3. Navegación - marcar archivos importantes
      harpoon2
      # 4. Ayuda - mostrar keymaps disponibles
      which-key-nvim
      # 5. Edición - autocierre de brackets
      nvim-autopairs
      # 6. Visual - líneas de indentación
      indent-blankline-nvim
      # 7. Edición - manipular pares (paréntesis, tags, etc)
      nvim-surround
      # 8. Productividad - resaltar TODO, FIXME, etc
      todo-comments-nvim
      # 9. Visual - mostrar colores CSS/hex en el editor
      nvim-colorizer-lua
      # 10. Búsqueda - mejorar búsqueda con Telescope
      telescope-fzf-native-nvim
    ];
    
    extraConfigLua = ''
      -- Gruvbox colorscheme
      require('gruvbox').setup({
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
      
      -- CMP (autocompletado)
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
        })
      })
      
      -- Lualine setup (manual)
      require('lualine').setup({
        options = { theme = 'gruvbox' }
      })
      
      -- Bufferline setup (manual) - Tabs estilo IDE
      require('bufferline').setup({
        options = {
          mode = 'buffers',
          numbers = 'ordinal',
          close_command = 'bdelete! %d',
          right_mouse_command = 'bdelete! %d',
          left_mouse_command = 'buffer %d',
          middle_mouse_command = nil,
          indicator = {
            icon = '▎',
            style = 'icon',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15,
          truncate_names = true,
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_update_in_insert = false,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = 'slant',
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              text_align = 'center',
              separator = true,
            },
          },
        },
        highlights = {
          buffer_selected = {
            bold = true,
            italic = false,
          },
        },
      })
      
      -- Keymaps para tabs (buffers)
      vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Siguiente buffer' })
      vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Buffer anterior' })
      vim.keymap.set('n', '<leader>bd', '<Cmd>bdelete<CR>', { desc = 'Cerrar buffer actual' })
      vim.keymap.set('n', '<leader>bo', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Cerrar otros buffers' })
      vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Ir al buffer 1' })
      vim.keymap.set('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', { desc = 'Ir al buffer 2' })
      vim.keymap.set('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', { desc = 'Ir al buffer 3' })
      vim.keymap.set('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', { desc = 'Ir al buffer 4' })
      vim.keymap.set('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', { desc = 'Ir al buffer 5' })
      
      -- Abrir/Cerrar buffers estilo VSCode (Cmd+t y Cmd+w)
      -- NOTA: Estas teclas Cmd pueden ser interceptadas por la terminal
      -- Si no funcionan, usa <leader>t y <leader>w como alternativas
      vim.keymap.set('n', '<leader>t', '<Cmd>enew<CR>', { desc = 'Nuevo buffer (Cmd+t)' })
      vim.keymap.set('n', '<leader>w', '<Cmd>bdelete<CR>', { desc = 'Cerrar buffer (Cmd+w)' })
      
      -- Intentar mapear Cmd+t y Cmd+w (funciona en GUI Neovim como Neovide)
      -- En terminal, estas teclas pueden ser capturadas por la terminal misma
      vim.keymap.set('n', '<D-t>', '<Cmd>enew<CR>', { desc = 'Nuevo buffer' })
      vim.keymap.set('n', '<D-w>', '<Cmd>bdelete<CR>', { desc = 'Cerrar buffer' })
      
      -- ToggleTerm setup - Múltiples terminales
      require('toggleterm').setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      })
      
      -- Terminal 1 - Horizontal (abajo)
      local Terminal = require('toggleterm.terminal').Terminal
      local term1 = Terminal:new({ 
        direction = 'horizontal', 
        count = 1,
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
      })
      vim.keymap.set('n', '<leader>t1', function() term1:toggle() end, { desc = 'Terminal 1 (horizontal)' })
      
      -- Terminal 2 - Vertical (derecha)
      local term2 = Terminal:new({ 
        direction = 'vertical', 
        count = 2,
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
      })
      vim.keymap.set('n', '<leader>t2', function() term2:toggle() end, { desc = 'Terminal 2 (vertical)' })
      
      -- Terminal 3 - Flotante
      local term3 = Terminal:new({ 
        direction = 'float', 
        count = 3,
        float_opts = {
          border = 'double',
        },
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
      })
      vim.keymap.set('n', '<leader>t3', function() term3:toggle() end, { desc = 'Terminal 3 (flotante)' })
      
      -- Terminal 4 - Horizontal pequeña (para comandos rápidos)
      local term4 = Terminal:new({ 
        direction = 'horizontal', 
        count = 4,
        size = 10,
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
      })
      vim.keymap.set('n', '<leader>t4', function() term4:toggle() end, { desc = 'Terminal 4 (pequeña)' })
      
      -- LazyGit terminal (si está instalado)
      local lazygit = Terminal:new({ 
        cmd = 'lazygit',
        direction = 'float', 
        count = 5,
        float_opts = {
          border = 'double',
        },
        on_open = function(term)
          vim.cmd('startinsert!')
        end,
        on_close = function(term)
          vim.cmd('startinsert!')
        end,
      })
      vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = 'LazyGit' })
      
      -- Treesitter setup (manual)
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
      
      -- Oil setup (manual) - file explorer pantalla completa
      require('oil').setup()
      vim.keymap.set('n', '1', '<CMD>Oil<CR>', { desc = 'Abrir explorador (pantalla completa)' })
      
      -- Neo-tree setup (manual) - sidebar tipo VSCode
      require('neo-tree').setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true },
        },
        window = {
          width = 30,
          position = 'left',
        },
      })
      vim.keymap.set('n', '<leader>e', '<CMD>Neotree toggle<CR>', { desc = 'Abrir árbol de archivos (sidebar)' })
      
      -- Comment setup (manual)
      require('nvim_comment').setup()
      
      -- GitHub Copilot setup
      require('copilot').setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node',
        server_opts_overrides = {},
      })
      
      -- Configuración de diagnostics (errores inline estilo VSCode)
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●', -- Icono antes del mensaje de error
          spacing = 4,
          source = 'if_many', -- Muestra la fuente si hay muchos
          severity = {
            min = vim.diagnostic.severity.HINT, -- Muestra todos los niveles
          },
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.HINT] = '⚑',
            [vim.diagnostic.severity.INFO] = '»',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
        },
        underline = true, -- Subrayar el código con error
        update_in_insert = false, -- No actualizar mientras escribís (evita distracciones)
        severity_sort = true, -- Ordenar por severidad
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      
      -- LSP setup (manual)
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Configurar servidores LSP
      local servers = { 
        'nil_ls',           -- Nix
        'lua_ls',           -- Lua
        'pyright',          -- Python
        'ts_ls',            -- TypeScript/JavaScript (incluye React/JSX/TSX)
        'eslint',           -- ESLint para JavaScript/TypeScript
      }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end
      
      -- Configuración especial para TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })
      
      -- Keymaps LSP estilo IntelliJ
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Find References' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
      
      -- Formatear código (útil para JS/TS/Python)
      vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Formatear código' })
      vim.keymap.set('v', '<leader>f', vim.lsp.buf.format, { desc = 'Formatear selección' })
      
      -- Trouble setup - Panel de diagnostics estilo VSCode
      require('trouble').setup({
        position = 'bottom', -- Panel en la parte inferior
        height = 10, -- Altura del panel
        width = 50,
        icons = true,
        mode = 'workspace_diagnostics', -- Muestra errores de todo el workspace
        severity = nil,
        fold_open = 'v',
        fold_closed = '>',
        group = true,
        padding = true,
        cycle_results = false,
        action_keys = {
          close = 'q',
          cancel = '<esc>',
          refresh = 'r',
          jump = {'<cr>', '<tab>'},
          open_split = {'<c-x>'},
          open_vsplit = {'<c-v>'},
          open_tab = {'<c-t>'},
          jump_close = {'o'},
          toggle_mode = 'm',
          switch_severity = 's',
          toggle_preview = 'P',
          hover = 'K',
          preview = 'p',
          open_code_href = 'c',
          close_folds = {'zM', 'zm'},
          open_folds = {'zR', 'zr'},
          toggle_fold = {'zA', 'za'},
          previous = 'k',
          next = 'j',
          help = '?',
        },
        multiline = true,
        indent_lines = true,
        win_config = { border = 'rounded' },
        auto_open = false, -- No abrir automáticamente
        auto_close = false, -- No cerrar automáticamente
        auto_preview = true,
        auto_fold = false,
        signs = {
          error = '✘',
          warning = '▲',
          hint = '⚑',
          information = '»',
          other = '?',
        },
        use_diagnostic_signs = true,
      })
      
      -- Keymaps para Trouble (panel de errores)
      vim.keymap.set('n', '<leader>xx', '<Cmd>Trouble diagnostics toggle<CR>', { desc = 'Diagnostics (Todos)' })
      vim.keymap.set('n', '<leader>xd', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Diagnostics (Buffer actual)' })
      vim.keymap.set('n', '<leader>xl', '<Cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = 'LSP Definitions' })
      vim.keymap.set('n', '<leader>xq', '<Cmd>Trouble qflist toggle<CR>', { desc = 'Quickfix List' })
      
      -- 1. GitSigns - cambios en el margen tipo GitLens
      require('gitsigns').setup({
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Siguiente cambio' })
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Cambio anterior' })
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
          vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { buffer = bufnr, desc = 'Stage selección' })
          vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { buffer = bufnr, desc = 'Reset selección' })
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = 'Stage buffer' })
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = 'Undo stage' })
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = 'Reset buffer' })
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
          vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, { buffer = bufnr, desc = 'Blame línea' })
          vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle blame' })
          vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = 'Diff este archivo' })
          vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr, desc = 'Diff vs HEAD' })
          vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = 'Toggle eliminado' })
        end,
      })
      
      -- 2. Telescope - búsqueda tipo Ctrl+P
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-n>'] = actions.cycle_history_next,
              ['<C-p>'] = actions.cycle_history_prev,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-c>'] = actions.close,
              ['<CR>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
            },
            n = {
              ['<esc>'] = actions.close,
              ['<CR>'] = actions.select_default,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-t>'] = actions.select_tab,
              ['j'] = actions.move_selection_next,
              ['k'] = actions.move_selection_previous,
            },
          },
          file_ignore_patterns = { 'node_modules', '.git/', '.cache/', '%.o', '%.a', '%.out', '%.class', '%.pdf', '%.mkv', '%.mp4', '%.zip' },
        },
        pickers = {
          find_files = {
            theme = 'dropdown',
            previewer = false,
          },
          buffers = {
            theme = 'dropdown',
            previewer = false,
          },
        },
      })
      telescope.load_extension('fzf')
      -- Keymaps Telescope
      vim.keymap.set('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = 'Buscar archivos (Ctrl+P)' })
      vim.keymap.set('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = 'Buscar texto en archivos' })
      vim.keymap.set('n', '<leader>fb', '<Cmd>Telescope buffers<CR>', { desc = 'Buscar buffers abiertos' })
      vim.keymap.set('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = 'Buscar en documentación' })
      vim.keymap.set('n', '<leader>fo', '<Cmd>Telescope oldfiles<CR>', { desc = 'Archivos recientes' })
      vim.keymap.set('n', '<leader>fs', '<Cmd>Telescope grep_string<CR>', { desc = 'Buscar palabra bajo cursor' })
      vim.keymap.set('n', '<leader>fr', '<Cmd>Telescope resume<CR>', { desc = 'Reanudar última búsqueda' })
      vim.keymap.set('n', '<leader>fc', '<Cmd>Telescope commands<CR>', { desc = 'Buscar comandos' })
      vim.keymap.set('n', '<leader>fk', '<Cmd>Telescope keymaps<CR>', { desc = 'Buscar keymaps' })
      
      -- 3. Harpoon - marcar archivos importantes
      local harpoon = require('harpoon')
      harpoon:setup()
      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Añadir a Harpoon' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Ver marcados Harpoon' })
      vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
      vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
      vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
      vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
      -- Navegación prev/next en Harpoon
      vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Harpoon anterior' })
      vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Harpoon siguiente' })
      
      -- 4. Which-key - ayuda de keymaps
      require('which-key').setup({
        preset = 'helix',
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        win = {
          border = 'rounded',
          padding = { 2, 2, 2, 2 },
        },
        show_help = true,
        show_keys = true,
        triggers = {
          { '<auto>', mode = 'nxso' },
        },
      })
      
      -- 5. Autopairs - cerrar brackets automáticamente
      require('nvim-autopairs').setup({
        check_ts = true, -- Usar treesitter para verificar
        ts_config = {
          lua = { 'string', 'source' },
          javascript = { 'template_string' },
          java = false,
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%)%>%]%)%}%,]]=],
          offset = 0,
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'PmenuSel',
          highlight_grey = 'LineNr',
        },
      })
      -- Integrar con CMP (autocompletado)
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
      
      -- 6. Indent-blankline - líneas guía de indentación
      require('ibl').setup({
        indent = {
          char = '│',
          tab_char = '│',
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          char = '▎',
        },
        exclude = {
          filetypes = {
            'help',
            'dashboard',
            'neo-tree',
            'Trouble',
            'lazy',
            'mason',
            'notify',
            'toggleterm',
            'lazyterm',
          },
        },
      })
      
      -- 7. Surround - manipular pares (ys, ds, cs)
      require('nvim-surround').setup({
        keymaps = {
          insert = '<C-g>s',
          insert_line = '<C-g>S',
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
          change_line = 'cS',
        },
      })
      
      -- 8. Todo-comments - resaltar TODO, FIXME, etc
      require('todo-comments').setup({
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = ' ',
            color = 'error',
            alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
          },
          TODO = { icon = ' ', color = 'info' },
          HACK = { icon = ' ', color = 'warning' },
          WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
          PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
          TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
        },
        gui_style = {
          fg = 'NONE',
          bg = 'BOLD',
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
          warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
          info = { 'DiagnosticInfo', '#2563EB' },
          hint = { 'DiagnosticHint', '#10B981' },
          default = { 'Identifier', '#7C3AED' },
          test = { 'Identifier', '#FF00FF' },
        },
        search = {
          command = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
          },
          pattern = [[\b(KEYWORDS):]],
        },
      })
      -- Keymaps para buscar TODOs
      vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Siguiente TODO' })
      vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'TODO anterior' })
      vim.keymap.set('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', { desc = 'Buscar TODOs' })
      vim.keymap.set('n', '<leader>xt', '<Cmd>TodoTrouble<CR>', { desc = 'TODOs en Trouble' })
      
      -- 9. Colorizer - mostrar colores CSS/hex
      require('colorizer').setup({
        filetypes = { '*' }, -- Todos los archivos
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = 'background', -- 'foreground' o 'background'
          tailwind = true, -- Soporte para colores Tailwind
          sass = { enable = false, parsers = { 'css' } },
          virtualtext = '■',
          virtualtext_inline = false,
          always_update = false,
        },
        buftypes = {},
      })
      
      -- 10. FZF-native - búsqueda veloz para Telescope (ya cargado arriba)
      -- No requiere configuración adicional, solo load_extension
    '';

    plugins = {
      # UI / plugins útiles - TODOS configurados manualmente arriba
      # lualine.enable = true;
      # treesitter.enable = true;
      # comment.enable = true;
      # oil.enable = true;

      # LSP - desactivado (configurado manualmente arriba)
      # lsp = {
      #   enable = true;
      #   servers = {
      #     nil_ls.enable = true;
      #     lua_ls.enable = true;
      #     pyright.enable = true;
      #   };
      # };
    };
  };
}
