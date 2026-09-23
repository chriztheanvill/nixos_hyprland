-- ============================================================
-- Shell
-- ============================================================
vim.o.shell          = "/usr/bin/zsh"

-- ============================================================
-- Opciones generales
-- ============================================================
local opt            = vim.opt

vim.g.mapleader      = " " -- cambiar a " " (space)
vim.g.maplocalleader = " " -- Opcional, para atajos específicos de tipos de archivo

opt.nu               = true
opt.fcs              = { eob = " " }
opt.hidden           = true
opt.wrap             = true
opt.wrapmargin       = 0
opt.linebreak        = true
opt.swapfile         = false
opt.backup           = false
opt.writebackup      = false
opt.encoding         = "utf-8"
opt.emoji            = true
opt.shortmess:append("c") -- era: vim.opt.shortmess = c  (bug: c era nil)
vim.o.pumborder       = "rounded"
vim.o.pumheight       = 15
-- opt.pumheight         = 10
opt.pumwidth          = 10 -- ancho mínimo
opt.pumblend          = 10 -- transparencia leve del popup
opt.winborder         = "rounded"
opt.ruler             = true
opt.splitbelow        = true
opt.splitright        = true
opt.errorbells        = false
opt.showmatch         = true
opt.ignorecase        = true
opt.hlsearch          = true
opt.incsearch         = true
opt.inccommand        = "nosplit"
opt.tabstop           = 2
opt.softtabstop       = 0
opt.expandtab         = true
opt.shiftwidth        = 2
opt.autoindent        = true
opt.smartindent       = true
opt.smarttab          = true
opt.copyindent        = true
opt.laststatus        = 3
opt.showtabline       = 1 -- Mostrar tabs: 0 nunca, 1 cuando hay 2 o mas, 2 siempre
opt.updatetime        = 250
opt.signcolumn        = "yes"
opt.mouse             = "a"
opt.clipboard         = "unnamedplus"
-- tanto cursorline y cursorlineopt tienen que estar juntas/activadas_al_mismo_tiempo
opt.cursorline        = true
opt.cursorlineopt     = "number"
-- opt.colorcolumn = "80"
-- opt.completeopt       = { "menuone", "noselect", "popup" }
opt.completeopt       = { "menu", "menuone", "noselect", "fuzzy", "popup" }
opt.completeitemalign = "kind,abbr,menu"
-- opt.completeitemalign = "abbr,kind,menu" -- default
-- vim.o.completeitemalign = "kind,abbr,menu"  -- ícono primero, como en VSCode
-- opt.completeitemalign = "abbr,menu,kind" -- kind al final
opt.spelllang         = "en_us,en,es"
-- opt.undofile    = true
-- opt.undodir     = vim.fn.expand("~/.config/nvim/vim-mundo")
opt.conceallevel      = 2
vim.opt.concealcursor = 'nc' -- oculta también en modo normal, no solo cuando el cursor no está en la línea
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Ctrl+C = ESC en todos los modos
vim.keymap.set({ "n", "i", "v", "x", "s" }, "<C-c>", "<Esc>",
  { remap = true, desc = "Ctrl+C actúa exactamente como ESC" })

-- Explore:
-- Ocultar el banner superior de ayuda que quita mucho espacio
-- vim.g.netrw_banner = 0

-- Abrir los archivos en una división vertical en lugar de reemplazarte el explorador
-- vim.g.netrw_browse_split = 4
-- Cambiar el ancho de Lexplore (por defecto es 25, aquí lo subimos al 30% de la pantalla)
vim.g.netrw_winsize = 25

-- Cambiar la ubicación del panel lateral
-- 0 = Abre a la izquierda (por defecto)
-- 1 = Abre a la derecha
vim.g.netrw_altv = 1

-- -- Fuentes de completado: buffer, ventanas, otros buffers, deshacer, tags, omnifunc (LSP)
-- vim.o.complete = ".^10,w,b,u,t"
vim.o.complete = ".^10,w,b,u,t,o"

-- Mantener 8 líneas de margen al hacer scroll (contexto visual)
opt.scrolloff = 10
opt.sidescrolloff = 10
-- Clipboard System
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy --type text/plain',
    ['*'] = 'wl-copy --type text/plain --primary',
  },
  paste = {
    ['+'] = 'wl-paste --no-newline',
    ['*'] = 'wl-paste --no-newline --primary',
  },
  cache_enabled = true,
}

-- Caracteres visibles para espacios
opt.list = true
opt.listchars = {
  space = "·",
  tab = "▸ ",
  trail = "•",
  extends = "⟩",
  precedes = "⟨",
  nbsp = "␣",
}
-- opt.listchars:append("space:⋅")

-- compatibiliad con vscode
-- vim.opt.listchars = { space = '·', tab = '→ ' }

-- o solamente activar para vscode
-- if vim.g.vscode then
-- --     vim.opt.list = true
--     vim.opt.listchars = { space = '·', tab = '→ ' }
-- end
-- if vim.g.vscode then
--   opt.list = false        -- deja que VSCode maneje renderWhitespace
--   opt.nu = false           -- deja que VSCode maneje los números de línea
--   opt.cursorline = false   -- opcional, VSCode ya resalta la línea activa
--   opt.signcolumn = "auto"  -- opcional, evita duplicar columnas de signos
--   opt.tabstop     = 4
--   opt.softtabstop = 4
--   opt.expandtab   = false
--   opt.shiftwidth  = 4
-- end

if not vim.g.vscode then
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·' }
end

-- Crear undodir si no existe
-- vim.fn.mkdir(vim.fn.expand("~/.config/nvim/vim-mundo"), "p")

-- Cambia el cwd al directorio del archivo/argumento inicial
-- Sirve para cuando estes en ~/Downloads y ejecutes `nvim /media/cris/Jazz/Documents/`
-- nvim tome el directorio como argumento y lo ponga como directorio base.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg and arg ~= "" then
      local dir = vim.fn.isdirectory(arg) == 1 and arg or vim.fn.fnamemodify(arg, ":p:h")
      vim.cmd("cd " .. vim.fn.fnameescape(dir))
    end
  end,
})

-- ============================================================
-- Cursor: restaurar posición al abrir archivo
-- ============================================================
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restaurar posición del cursor al abrir un archivo",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Just if the theme has bad frameborders
-- highlight WinSeparator guibg=None
--
-- "vim.opt.ttyfast                 " Speed up scrolling in Vim
-- "vim.opt.t_Co=256				"support 256 colors"
--
-- " vim.opt.noswapfile            " disable creating swap file
-- " vim.opt.backupdir=~/.cache/vim " Directory to store backup files.
--
-- "" Spell check
-- "":vim.opt.spell
-- vim.opt.spelllang = "en_us,en,es"

-- Show 5 spell checking candidates at most."
-- vim.opt.spellsuggest = { "best", 5 }

-- nnoremap <silent> <leader><F11> :vim.opt.spell!<cr>
-- inoremap <silent> <leader><F11> <C-O>:vim.opt.spell!<cr>

-- -- Undo
-- Enable persistent undo so that undo history persists across vim sessions
-- vim.opt.undofile = true
-- vim.opt.undodir = "/home/cris/.config/nvim/vim-mundo"


-- -- Fold
-- Configuración en init.lua (ejemplos de opciones)
-- vim.opt.foldmethod = "indent"  -- Pliega según la indentación del código (muy común)
vim.opt.foldmethod = "expr" -- Usa una expresión (ideal para árboles de sintaxis como Treesitter)
-- vim.opt.foldmethod = "marker"  -- Pliega usando marcas de texto como {{{ y }}}

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1

--vim.opt.termguicolors = true

-- ============================================================
-- Autoclose: paréntesis, brackets, comillas
-- ============================================================
local pairs_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

for open, close in pairs(pairs_map) do
  -- Al escribir el caracter de apertura, inserta el cierre y mueve cursor al medio
  vim.keymap.set("i", open, function()
    -- Para comillas: si el char siguiente es igual al cierre, solo mover cursor
    local col  = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local next = line:sub(col + 1, col + 1)

    if open == close and next == close then
      -- Saltar sobre el cierre existente
      return "<Right>"
    end
    return open .. close .. "<Left>"
  end, { expr = true, buffer = false }
  )

  -- Al escribir el caracter de cierre sobre uno existente, saltar en lugar de duplicar
  if open ~= close then
    vim.keymap.set("i", close, function()
      local col  = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      local next = line:sub(col + 1, col + 1)
      if next == close then
        return "<Right>"
      end
      return close
    end, { expr = true, buffer = false }
    )
  end
end

-- Backspace elimina el par completo si el cursor está entre ellos
vim.keymap.set("i", "<BS>", function()
  local col        = vim.api.nvim_win_get_cursor(0)[2]
  local line       = vim.api.nvim_get_current_line()
  local prev       = line:sub(col, col)
  local next       = line:sub(col + 1, col + 1)
  local auto_pairs = { ["("] = ")", ["["] = "]", ["{"] = "}", ['"'] = '"', ["'"] = "'", ["`"] = "`" }
  if auto_pairs[prev] == next then
    return "<Right><BS><BS>"
  end
  return "<BS>"
end, { expr = true }
)

-- Triple backtick para bloques de código en markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.keymap.set("i", "```", "```<CR>```<Up><End>", { buffer = true, desc = "Bloque de código markdown" })
  end,
})

-- ============================================================
-- Markdown: continuar listas al presionar Enter / o / O
-- ============================================================
--         vim.api.nvim_create_autocmd("FileType", {
--             pattern = { "markdown" },
--             callback = function()
--             -- Enter en insert mode: continuar lista
--             vim.keymap.set("i", "<CR>", function()
--             local line = vim.api.nvim_get_current_line()
--
--             -- Lista con guión:  "- texto"  o  "  - texto"
--             local indent, bullet = line:match("^(%s*)(-%s)")
--             if indent and bullet then
--                 -- Si la línea sólo tiene el bullet sin texto, terminar la lista
--                 if line:match("^%s*-%s*$") then
--                     return "<C-u><CR>"
--                     end
--                     return "<CR>" .. indent .. bullet
--                     end
--
--                     -- Lista numerada: "1. texto" o "  2. texto"
--                     local ind, num, dot = line:match("^(%s*)(%d+)(%.%s)")
--                     if ind and num and dot then
--                         if line:match("^%s*%d+%.%s*$") then
--                             return "<C-u><CR>"
--                             end
--                             return "<CR>" .. ind .. tostring(tonumber(num) + 1) .. dot
--                             end
--
--                             -- Lista con asterisco: "* texto"
--                             local ind2, star = line:match("^(%s*)(%*%s)")
--                             if ind2 and star then
--                                 if line:match("^%s*%*%s*$") then
--                                     return "<C-u><CR>"
--                                     end
--                                     return "<CR>" .. ind2 .. star
--                                     end
--
--                                     return "<CR>"
--                                     end, { expr = true, buffer = true, desc = "Continuar lista markdown" })
--
--             -- `o` en normal mode: nueva línea abajo continuando lista
--             vim.keymap.set("n", "o", function()
--             local line = vim.api.nvim_get_current_line()
--
--             local indent, bullet = line:match("^(%s*)(-%s)")
--             if indent and bullet then
--                 return "o" .. indent .. bullet
--                 end
--
--                 local ind, num, dot = line:match("^(%s*)(%d+)(%.%s)")
--                 if ind and num and dot then
--                     return "o" .. ind .. tostring(tonumber(num) + 1) .. dot
--                     end
--
--                     local ind2, star = line:match("^(%s*)(%*%s)")
--                     if ind2 and star then
--                         return "o" .. ind2 .. star
--                         end
--
--                         return "o"
--                         end, { expr = true, buffer = true, desc = "Nueva línea abajo con lista" })
--
--             -- `O` en normal mode: nueva línea arriba (sin incrementar número)
--         vim.keymap.set("n", "O", function()
--         local line = vim.api.nvim_get_current_line()
--
--         local indent, bullet = line:match("^(%s*)(-%s)")
--         if indent and bullet then
--             return "O" .. indent .. bullet
--             end
--
--             local ind, _, dot = line:match("^(%s*)(%d+)(%.%s)")
--             if ind and dot then
--                 return "O" .. ind .. "1" .. dot
--                 end
--
--                 local ind2, star = line:match("^(%s*)(%*%s)")
--                 if ind2 and star then
--                     return "O" .. ind2 .. star
--                     end
--
--                     return "O"
--                     end, { expr = true, buffer = true, desc = "Nueva línea arriba con lista" })
--         end,
--         })

-- ===========================================
-- ===========================================
-- Keymaps globales para abrir Telescope
-- local map = function(keys, fn, desc)
--   vim.keymap.set("n", keys, fn, { desc = desc })
-- end
--
