require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = { ["@parameter.inner"] = "v" },
    },
})

local select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer") end)
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner") end)
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer") end)
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner") end)

local move = require("nvim-treesitter-textobjects.move")
vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer") end)
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer") end)

-- 
-- Explicacion
-- ## Los modos: `"x"` y `"o"`
--
-- - **`x`** = Visual mode (selección visual)
-- - **`o`** = Operator-pending mode — el estado intermedio después de presionar un operador como `d`, `c`, `y`, antes de darle el "objeto" sobre el cual actuar.
--
-- Esto es exactamente el mismo mecanismo que los text objects nativos de Vim como `iw` (inner word) o `ap` (a paragraph). `af`/`if` los extiende a "función" usando el árbol sintáctico en vez de heurísticas de texto.
--
-- ## `af` / `if` — selección de función
--
-- `select.select_textobject("@function.outer")` selecciona el nodo `@function.outer` (la query treesitter que marca "función completa, incluyendo firma/llaves") bajo o alrededor del cursor.
--
-- - **`af`** = "a function" → función completa (firma + cuerpo + llaves)
-- - **`if`** = "inner function" → solo el cuerpo (sin firma)
--
-- Cómo se usan en la práctica:
--
-- ```
-- daf    -- delete a function     → borra la función completa
-- dif    -- delete inner function → borra solo el cuerpo, deja la firma vacía
-- caf    -- change a function     → borra función completa y entra a insert
-- vaf    -- visual select a function
-- yif    -- yank inner function
-- ```
--
-- Ejemplo en C:
-- ```c
-- int suma(int a, int b) {   // <- con el cursor aquí...
--     return a + b;
-- }
-- ```
-- `daf` con el cursor en cualquier parte de esa función la borra entera (incluyendo `int suma(...) { ... }`). `dif` solo borra `return a + b;`, dejando `int suma(int a, int b) {\n\n}`.
--
-- ## `ac` / `ic` — lo mismo pero para clases
--
-- Igual pero con `@class.outer` / `@class.inner`. En C++ funciona con `class`/`struct`; en Lua no aplica mucho (no hay clases nativas) a menos que la query de Lua defina algo equivalente (raramente).
--
-- ## `]f` / `[f` — saltar entre funciones
--
-- Estos no seleccionan nada, solo **mueven el cursor**:
--
-- - **`]f`** → salta al inicio de la **siguiente** función
-- - **`[f`** → salta al inicio de la función **anterior**
--
-- Al estar en modos `{"n", "x", "o"}`:
-- - En **normal mode**, simplemente mueve el cursor.
-- - En **visual mode**, extiende la selección hasta ahí.
-- - En **operator-pending**, se combina con un operador: `d]f` borra desde el cursor hasta el inicio de la siguiente función (como `dw` pero con funciones).
--
-- Combinado con `af`, un flujo típico es: `]f` para saltar a la siguiente función, luego `daf` para borrarla completa — o directamente `d]f` si solo quieres borrar "hasta ahí".
--
-- ## Nota importante: `af`/`if` chocan con Vim nativo
--
-- Vim no tiene `af`/`if` nativos por defecto (esos no existen como builtin), así que no hay conflicto ahí. Pero si usas algún plugin de "surround" o similar que también use `f`, revisa que no se pisen. Con tu config actual (WASD para Telescope) no hay colisión, esos mapeos son de otro namespace (`x`/`o` vs `n` de Telescope).
