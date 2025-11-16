-- ============================
-- Configuration Neovim minimale
-- Basée sur la config Vim personnelle
-- ============================

-- ============================
-- 1. Settings de base
-- ============================

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options générales
vim.opt.number = true                -- Numéros de ligne
vim.opt.relativenumber = true        -- Numéros relatifs
vim.opt.cursorline = true            -- Highlight ligne courante
vim.opt.scrolloff = 7                -- Garde 7 lignes visibles en haut/bas
vim.opt.wrap = true                  -- Wrap automatique
vim.opt.linebreak = true             -- Break sur les mots
vim.opt.shortmess:append("I")        -- Désactiver l'écran d'intro au démarrage

-- Indentation
vim.opt.autoindent = true
vim.opt.expandtab = true             -- Utiliser des espaces au lieu de tabs
vim.opt.tabstop = 4                  -- Tab = 4 espaces
vim.opt.shiftwidth = 4               -- Indent = 4 espaces
vim.opt.smartindent = true

-- Recherche
vim.opt.ignorecase = true            -- Ignorer la casse
vim.opt.smartcase = true             -- Sauf si majuscule dans la recherche
vim.opt.hlsearch = true              -- Highlight les résultats
vim.opt.incsearch = true             -- Recherche incrémentale

-- Interface
vim.opt.termguicolors = true         -- Couleurs 24-bit
vim.opt.background = 'dark'
vim.opt.showmode = false             -- Masquer le mode (affiché par lualine)
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.list = true                  -- Afficher les caractères invisibles
vim.opt.listchars = { tab = '→ ', trail = '·', extends = '>', precedes = '<' }

-- Comportement
vim.opt.hidden = true                -- Buffers cachés
vim.opt.backup = false               -- Pas de backup
vim.opt.writebackup = false          -- Pas de writebackup
vim.opt.swapfile = false             -- Pas de swapfile
vim.opt.timeoutlen = 500             -- Délai pour les mappings
vim.opt.history = 1000               -- Historique de 1000 commandes
vim.opt.undolevels = 150
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:list,full'

-- Encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Désactiver le folding
vim.opt.foldenable = false

-- Désactiver les warnings de deprecation (temporaire)
vim.deprecate = function() end

-- ============================
-- 2. Autocmds (indentation par filetype)
-- ============================

local function set_indent(pattern, ts, sw)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = pattern,
        callback = function()
            vim.opt_local.tabstop = ts
            vim.opt_local.shiftwidth = sw
            vim.opt_local.expandtab = true
        end,
    })
end

set_indent({"html", "javascript", "vue", "svelte"}, 2, 2)

-- ============================
-- 3. Mappings
-- ============================

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Scroll plus rapide
map('n', 'J', '2<C-e>')
map('n', 'K', '3<C-y>')

-- Navigation buffers (sera amélioré avec bufferline)
map('n', '<Tab>', ':bnext<CR>')
map('n', '<S-Tab>', ':bprevious<CR>')
map('n', '<S-F12>', ':bnext<CR>')
map('n', '<S-F11>', ':bprevious<CR>')

-- Indent/Dedent en mode insertion
map('i', '<S-Tab>', '<C-o><<')

-- Reload config
map('n', '<Leader><CR>', ':source ~/.config/nvim/init.lua<CR>', { desc = 'Reload config' })

-- ============================
-- 4. Bootstrap lazy.nvim
-- ============================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================
-- 5. Plugins
-- ============================

require("lazy").setup({
    -- Colorscheme
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- Nvim-tree (remplace NERDTree)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<F9>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
            { "<leader><Tab>", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
        },
        opts = {
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
        },
    },

    -- Bufferline (gestion des buffers)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        lazy = false,  -- Charger au démarrage
        keys = {
            { "<F12>", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
        },
        opts = {
            options = {
                mode = "buffers",
                separator_style = "slant",
                always_show_bufferline = true,
                show_buffer_close_icons = false,
                show_close_icon = false,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true,
                    },
                },
            },
        },
    },

    -- Lualine (statusline - remplace vim-airline)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = 'gruvbox'
            },
        },
    },

    -- Git signs (remplace vim-gitgutter)
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    -- Fugitive (git)
    "tpope/vim-fugitive",

    -- Surround
    "tpope/vim-surround",

    -- Comment (remplace nerdcommenter)
    {
        "numToStr/Comment.nvim",
        keys = {
            { "<leader>c<leader>", mode = { "n", "v" }, desc = "Toggle comment" },
        },
        config = function()
            require('Comment').setup()
            -- Mapping personnalisé pour <leader>c<leader>
            vim.keymap.set('n', '<leader>c<leader>', function()
                return vim.api.nvim_get_vvar('count') == 0
                    and '<Plug>(comment_toggle_linewise_current)'
                    or '<Plug>(comment_toggle_linewise_count)'
            end, { expr = true, silent = true, desc = 'Toggle comment line' })

            vim.keymap.set('v', '<leader>c<leader>', '<Plug>(comment_toggle_linewise_visual)',
                { silent = true, desc = 'Toggle comment selection' })
        end,
    },

    -- FZF
    {
        "junegunn/fzf",
        build = "./install --bin",
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        keys = {
            { "<C-p>", "<cmd>FZF<cr>", desc = "Find files" },
            { "<leader>p", "<cmd>Buffers<cr>", desc = "Find buffers" },
        },
        config = function()
            vim.g.fzf_preview_window = 'right:60%'
        end,
    },

    -- Ripgrep
    {
        "duane9/nvim-rg",
    },

    -- Colorizer (affiche les couleurs CSS)
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup({
                '*',  -- Activer pour tous les filetypes
            }, {
                RGB      = true,  -- #RGB
                RRGGBB   = true,  -- #RRGGBB
                names    = true,  -- "red", "blue", etc.
                RRGGBBAA = true,  -- #RRGGBBAA
                rgb_fn   = true,  -- rgb(), rgba()
                hsl_fn   = true,  -- hsl(), hsla()
                css      = true,  -- CSS colors
                css_fn   = true,  -- CSS functions
            })
        end,
    },

    -- Sneak (navigation rapide)
    {
        "justinmk/vim-sneak",
        config = function()
            vim.g['sneak#label'] = 1
        end,
    },

    -- Copilot (nécessite Node.js >= 18)
    "github/copilot.vim",

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "│",
            },
            scope = {
                enabled = false,
            },
        },
    },

    -- Treesitter (syntaxe moderne)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "html", "css", "python" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

})

-- ============================
-- LSP Configuration native (Neovim 0.11+)
-- ============================

-- Keymaps LSP (adaptés AZERTY)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- gd = Go to Definition (aller à la définition)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

        -- <leader>h = Afficher la documentation hover
        vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)

        -- <leader>n / <leader>N = Diagnostic suivant/précédent
        vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<leader>N', vim.diagnostic.goto_prev, opts)

        -- <leader>e = Afficher l'erreur en float
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
    end,
})

-- Démarrer Pyright automatiquement pour les fichiers Python
-- Installation requise : pip install pyright
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.lsp.start({
            name = 'pyright',
            cmd = { 'pyright-langserver', '--stdio' },
            root_dir = vim.fs.root(0, { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' }),
        })
    end,
})

-- ============================
-- 6. Fonction Format
-- ============================

function Format()
    vim.cmd('retab')
    vim.cmd([[%s/\s\+$//e]])
    print("Format: trailing whitespace removed and tabs reset")
end

map('n', '<leader>f', '<cmd>lua Format()<cr>', { desc = 'Format file' })
