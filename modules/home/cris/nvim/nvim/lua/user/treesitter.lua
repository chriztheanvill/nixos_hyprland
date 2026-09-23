-- install tree-sitter
-- fedora: sudo dnf install tree-sitter-cli

local ts = require("nvim-treesitter")

ts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = { "zig", "markdown", "markdown_inline", "sql", "lua", "c", "cpp", "gdscript", "bash", "nix" }

-- sqlite: el parser en nvim-treesitter que cubre archivos de esquema/consultas SQLite
-- normalmente se usa vía el filetype "sql" (no hay un parser "sqlite" separado,
-- SQLite usa el mismo dialecto sql en la práctica); si necesitas resaltar
-- archivos .db con contenido SQL embebido, usa "sql" igualmente.

-- Instala los parsers (asíncrono). Si quieres bloquear hasta que termine
-- (por ejemplo al bootstrapear), usa :wait()
ts.install(parsers):wait(300000)

local ts_filetypes = { "zig", "markdown", "sql", "lua", "c", "cpp", "gdscript", "bash", "sh", "nix" }

-- Habilitar highlighting via treesitter para esos filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    vim.treesitter.start()
  end,
})

-- Habilitar folds basados en treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})

-- Habilitar indentación experimental basada en treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
