local fzf     = require("fzf-lua")
local actions = require("fzf-lua.actions")

fzf.setup({
  "telescope", -- perfil base: look & feel + keybinds más cercanos a telescope

  -- win = {
  --   on_create = function()
  --     vim.cmd("stopinsert") -- equivalente a initial_mode = "normal"
  --   end,
  -- },

  keymap = {
    fzf = {
      -- Navegación estilo WASD (tu flujo en modo normal)
      -- ["s"]         = "down",
      -- ["w"]         = "up",
      -- ["a"]         = "abort",  -- cerrar (telescope: actions.close)
      -- ["d"]         = "accept", -- abrir seleccionado
      -- ["q"]         = "abort",
      ["esc"] = "abort",

      -- Previsualización (telescope: preview_scrolling_up/down)
      -- ["ctrl-u"]    = "preview-half-page-up",
      -- ["ctrl-d"]    = "preview-half-page-down",

      -- Páginas en la lista
      -- ["page-up"]   = "page-up",
      -- ["page-down"] = "page-down",
    },
  },

  actions = {
    files = {
      ["default"] = actions.file_edit_or_qf, -- <CR>: abrir
      ["ctrl-x"]  = actions.file_split,      -- split horizontal
      ["ctrl-v"]  = actions.file_vsplit,     -- split vertical
      ["ctrl-t"]  = actions.file_tabedit,    -- nueva tab
    },
  },

  -- files(): usa fd automáticamente si existe (equivale a tu builtin.fd)
  files = {
    hidden = false, -- como tu find_files por defecto
  },

  oldfiles = {
    include_current_session = true,
  },
})

-- <C-c> en el terminal del picker: pasar a modo normal (no mata fzf)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fzf",
  callback = function(ev)
    vim.keymap.set("t", "<C-c>", "<C-\\><C-n>", { buffer = ev.buf, silent = true })
  end,
})

local map = function(keys, fn, desc)
  vim.keymap.set("n", keys, fn, { desc = desc })
end

-- Archivos y texto
map("<leader>ff", function() fzf.files() end, "Find files (fd)")
map("<leader>fg", function() fzf.live_grep() end, "Grep en vivo")
map("<leader>fw", function() fzf.grep_cword() end, "Palabra bajo cursor")
vim.keymap.set("x", "<leader>fw", function() fzf.grep_visual() end, { desc = "Grep selección" })

map("<leader>fo", function()
  fzf.files({ cwd = vim.fn.expand("%:p:h") })
end, "FzfLua: archivos en carpeta actual")

-- Buffers y recientes (sort_mru / sort_lastused)
map("<leader>fr", function() fzf.buffers({ sort_mru = true }) end, "Buffers (MRU)")
map("<leader>fR", function() fzf.oldfiles() end, "Archivos recientes")

-- Carpeta del archivo actual
map("<leader>fe", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  fzf.files({ cwd = dir })
end, "Archivos de la carpeta actual")
-- Versión "sin subcarpetas" de tu telescope original:
map("<leader>fE", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then dir = vim.fn.getcwd() end
  fzf.files({ cwd = dir, fd_opts = "--type f --max-depth 1" })
end, "Archivos solo de esta carpeta")

map("<leader>fz", function() fzf.blines() end, "Fuzzy find en buffer")

-- LSP
map("<leader>fs", function() fzf.lsp_document_symbols() end, "Símbolos del archivo")
map("<leader>fS", function() fzf.lsp_workspace_symbols() end, "Símbolos del proyecto")
map("<leader>fD", function() fzf.diagnostics_workspace() end, "Diagnósticos LSP")
map("<leader>fd", function() fzf.lsp_references() end, "Referencias")
map("<leader>fi", function() fzf.lsp_implementations() end, "Implementaciones")

-- Git
map("<leader>gc", function() fzf.git_commits() end, "Commits git")
map("<leader>gb", function() fzf.git_branches() end, "Ramas git")
map("<leader>gs", function() fzf.git_status() end, "Status git")

-- Nvim
map("<leader>fk", function() fzf.keymaps() end, "Keymaps")
map("<leader>fC", function() fzf.commands() end, "Comandos")
map("<leader>fh", function() fzf.helptags() end, "Help tags")
map("<leader>ft", function() fzf.filetypes() end, "Filetypes")
