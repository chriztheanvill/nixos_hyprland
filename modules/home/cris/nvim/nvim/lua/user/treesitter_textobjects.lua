-- ============================================================
-- Treesitter Textobjects
-- ============================================================
require("nvim-treesitter-textobjects").setup({
    select = {
        -- Extiende la selección automáticamente a los objetos que la contienen
        lookahead = true,
        -- Modo de selección por tipo de captura (por defecto todo es "charwise")
        selection_modes = {
            ["@parameter.inner"] = "v",  -- selección charwise
            ["@function.outer"]  = "V",  -- selección linewise
            ["@class.outer"]     = "V",  -- selección linewise
        },
        include_surrounding_whitespace = false,
    },
    move = {
        set_jumps = true, -- guarda posiciones en el jumplist (Ctrl-o / Ctrl-i)
    },
})

local select = require("nvim-treesitter-textobjects.select")
local move   = require("nvim-treesitter-textobjects.move")
local swap   = require("nvim-treesitter-textobjects.swap")
-- local lsp_interop = require("nvim-treesitter-textobjects.lsp_interop")

-- ------------------------------------------------------------
-- Selección de text objects (modos visual y operator-pending)
-- Ejemplos de uso: vaf (seleccionar función), dac (borrar clase), yiP (yank parámetro)
-- ------------------------------------------------------------
local xo = { "x", "o" }

vim.keymap.set(xo, "af", function() select.select_textobject("@function.outer") end, { desc = "TS: función (outer)" })
vim.keymap.set(xo, "if", function() select.select_textobject("@function.inner") end, { desc = "TS: función (inner)" })

vim.keymap.set(xo, "ac", function() select.select_textobject("@class.outer") end, { desc = "TS: clase (outer)" })
vim.keymap.set(xo, "ic", function() select.select_textobject("@class.inner") end, { desc = "TS: clase (inner)" })

vim.keymap.set(xo, "aP", function() select.select_textobject("@parameter.outer") end, { desc = "TS: parámetro (outer)" })
vim.keymap.set(xo, "iP", function() select.select_textobject("@parameter.inner") end, { desc = "TS: parámetro (inner)" })

vim.keymap.set(xo, "aa", function() select.select_textobject("@assignment.outer") end, { desc = "TS: asignación (outer)" })
vim.keymap.set(xo, "ia", function() select.select_textobject("@assignment.inner") end, { desc = "TS: asignación (inner)" })

vim.keymap.set(xo, "al", function() select.select_textobject("@loop.outer") end, { desc = "TS: loop (outer)" })
vim.keymap.set(xo, "il", function() select.select_textobject("@loop.inner") end, { desc = "TS: loop (inner)" })

vim.keymap.set(xo, "ai", function() select.select_textobject("@conditional.outer") end, { desc = "TS: condicional (outer)" })
vim.keymap.set(xo, "ii", function() select.select_textobject("@conditional.inner") end, { desc = "TS: condicional (inner)" })

vim.keymap.set(xo, "a/", function() select.select_textobject("@comment.outer") end, { desc = "TS: comentario" })

-- ------------------------------------------------------------
-- Movimiento entre text objects (salta al inicio/fin del siguiente/anterior)
-- ------------------------------------------------------------
local nxo = { "n", "x", "o" }

vim.keymap.set(nxo, "]f", function() move.goto_next_start("@function.outer") end, { desc = "TS: siguiente función (inicio)" })
vim.keymap.set(nxo, "]F", function() move.goto_next_end("@function.outer") end, { desc = "TS: siguiente función (fin)" })
vim.keymap.set(nxo, "[f", function() move.goto_previous_start("@function.outer") end, { desc = "TS: función anterior (inicio)" })
vim.keymap.set(nxo, "[F", function() move.goto_previous_end("@function.outer") end, { desc = "TS: función anterior (fin)" })

vim.keymap.set(nxo, "]c", function() move.goto_next_start("@class.outer") end, { desc = "TS: siguiente clase" })
vim.keymap.set(nxo, "[c", function() move.goto_previous_start("@class.outer") end, { desc = "TS: clase anterior" })

vim.keymap.set(nxo, "]a", function() move.goto_next_start("@parameter.inner") end, { desc = "TS: siguiente parámetro" })
vim.keymap.set(nxo, "[a", function() move.goto_previous_start("@parameter.inner") end, { desc = "TS: parámetro anterior" })

-- ------------------------------------------------------------
-- Intercambiar parámetros/argumentos de posición (muy útil en C/C++/Lua)
-- ------------------------------------------------------------
vim.keymap.set("n", "<leader>Ta", function() swap.swap_next("@parameter.inner") end, { desc = "TS: mover parámetro a la derecha" })
vim.keymap.set("n", "<leader>TA", function() swap.swap_previous("@parameter.inner") end, { desc = "TS: mover parámetro a la izquierda" })

-- ------------------------------------------------------------
-- Selección de la función/clase actual usando LSP (fallback si no hay query TS)
-- ------------------------------------------------------------
-- vim.keymap.set("n", "<leader>rf", function()
--     lsp_interop.peek_definition_code("@function.outer")
-- end, { desc = "TS: peek definición de función" })
