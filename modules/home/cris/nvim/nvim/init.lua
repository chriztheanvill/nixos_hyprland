-- neovimcraft: https://neovimcraft.com/
--
-- commands:
-- :lua vim.pack.update()
--  -- luego :w para aplicar los cambios
--      o `:up` o `:update`
--
--  recargar (sirve para cuando se agrega un nuevo plugin)
--    :source %
--
-- ============================================================
-- Opciones generales
-- ============================================================
require("settings")

-- version compatible con otros editores
-- ============================================================
-- Paquetes
-- ============================================================
if not vim.g.vscode then -- para que vscode no los vea
  vim.pack.add({
    "https://github.com/nvim-tree/nvim-web-devicons",

    -- -- telescope
    -- "https://github.com/nvim-lua/plenary.nvim",
    -- "https://github.com/nvim-telescope/telescope.nvim",
    -- "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    -- "https://github.com/nvim-telescope/telescope-project.nvim",
    -- "https://github.com/nvim-telescope/telescope-file-browser.nvim",

    -- -- snacks
    "https://github.com/folke/snacks.nvim",

    -- fzf-lua -- muy simple, consume bastante ram
    -- "https://github.com/ibhagwan/fzf-lua",

    -- projects
    -- "https://www.github.com/olimorris/persisted.nvim",
    -- "https://github.com/wsdjeg/rooter.nvim",

    -- DAP
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",

    -- Tree Sitter
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

    -- leap
    "https://github.com/folke/flash.nvim",
    -- 'https://codeberg.org/andyg/leap.nvim',
    -- lsp
    'https://github.com/neovim/nvim-lspconfig',
    -- lualine
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Tema
    "https://github.com/scottmckendry/cyberdream.nvim",

    -- Render markdown
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    -- "https://github.com/the-mayankjha/fk_markdown.nvim", -- me gusto mucho
    -- "https://github.com/delphinus/md-render.nvim", -- cuando madure
    -- optional para `md-render.nvim`
    -- "https://github.com/delphinus/budoux.lua", -- creo que es para recortar/achicar texto

    -- Indent guides
    "https://github.com/lukas-reineke/indent-blankline.nvim",

    -- git
    "https://github.com/lewis6991/gitsigns.nvim",

    -- nixos
    "https://github.com/NotAShelf/direnv.nvim",
  })

  vim.cmd("packadd nvim.difftool")
  vim.cmd("packadd nvim.undotree")

  -- Opcional: Atajos de teclado prácticos
  vim.keymap.set("n", "<leader>ut", "<cmd>Undotree<CR>", { desc = "Toggle Undotree" })
end

if not vim.g.vscode then
  require("themes")
  require("user.lualine")
  require("user.markdown")
  -- require("user.telescope") -- viejo
  require("user.snacks")
  -- require("user.fzf_lua") -- muy simple, consume bastante ram
  require("user.indent_guides")
  require("user.treesitter")
  require("user.treesitter_textobjects")
  require("user.git_signs")
  -- require("user.leap")
  require("user.flash")
  -- nixos

  require("code.zig")
  require("code.ziggity")

  require("user.lsp")
  require("user.dap")

  require("user.direnv_config")
  -- require("user.persisted") -- meh
  -- require("user.rooter")
end

-- -- Markdown
-- para que funcione lsp y poder ver los headers
-- curl -L https://github.com/artempyanykh/marksman/releases/latest/download/marksman-linux-x64 -o marksman
-- chmod +x marksman
-- mv marksman ~/.local/bin/
-- o (pero no lo he intentado)
-- sudo mv marksman /usr/local/bin/

-- vscode Ctrl + 6, cambiar entre buffers:
-- En vscode usar Ctrl + p para buscar: Open keyboard shortcuts (json), asi tiene que quedar el archivo
--
-- [
--   {
--     "key": "ctrl+6",
--     "command": "-workbench.action.focusSixthEditorGroup"
--   },
--   {
--     "key": "ctrl+6",
--     "command": "workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup",
--     "when": "!activeEditorGroupEmpty"
--   },
--   {
--     "key": "ctrl+6",
--     "command": "workbench.action.quickOpenNavigateNextInEditorPicker",
--     "when": "inEditorsPicker && inQuickOpen"
--   }
-- ]
--

-- -- OLD
-- -- ============================================================
-- -- Paquetes
-- -- ============================================================
-- vim.pack.add({
--   -- Tema
--   -- "https://github.com/folke/tokyonight.nvim", -- muy azul
--   "https://github.com/scottmckendry/cyberdream.nvim", -- bueno
--   -- "https://github.com/olimorris/onedarkpro.nvim",
--   -- { src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" }, -- bueno
--
--   -- Iconos
--   "https://github.com/nvim-tree/nvim-web-devicons",
--
--   -- Render markdown
--   "https://github.com/MeanderingProgrammer/render-markdown.nvim",
--
--   -- Telescope
--   "https://github.com/nvim-lua/plenary.nvim",
--   "https://github.com/nvim-telescope/telescope.nvim",
--   "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
--   "https://github.com/nvim-telescope/telescope-project.nvim",
--   "https://github.com/nvim-telescope/telescope-file-browser.nvim",
--
--   -- Indent guides
--   "https://github.com/lukas-reineke/indent-blankline.nvim",
--
--   -- DAP
--   "https://github.com/mfussenegger/nvim-dap",
--   "https://github.com/rcarriga/nvim-dap-ui",
--   "https://github.com/nvim-neotest/nvim-nio", -- dependencia requerida por dap-ui
-- })
--
-- require("themes")
-- require("user.lsp")
-- require("user.markdown")
-- require("user.telescope")
-- require("user.indent_guides")
-- require("user.dap")
--
