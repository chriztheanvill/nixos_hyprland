-- ============================================================
-- flash.
-- ============================================================
require("flash").setup({
  modes = {
    char = {
      jump_labels = true,
    },
  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash' })

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

vim.keymap.set({ 'o', 'x' }, 'R', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

vim.keymap.set('c', '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

-- Explicacion
-- Te explico qué hace cada uno, con ejemplos concretos de uso:
--
-- ## `s` (normal, visual, operator-pending) → `require('flash').jump()`
--
-- Es el keybinding principal. Al presionarlo, Flash resalta con etiquetas (letras) los puntos de salto visibles en pantalla que coinciden con los caracteres que escribas después.
--
-- **Cómo se usa:**
-- 1. Presionas `s`
-- 2. Escribes 1-2 caracteres (ej: `fu` si quieres saltar a "function")
-- 3. Flash marca con una letra (label) cada ocurrencia visible de "fu"
-- 4. Presionas esa letra y saltas directamente ahí
--
-- Funciona en modo normal (saltar el cursor), visual (extender selección hasta ahí) y operator-pending — por ejemplo `d` + `s` + `fu` + label borra desde el cursor hasta ese punto.
--
-- ## `S` (normal, visual, operator-pending) → `require('flash').treesitter()`
--
-- Salto basado en la estructura sintáctica del código (usa Treesitter), no en texto. Al presionarlo, resalta nodos del árbol sintáctico (funciones, bloques, expresiones, argumentos) con etiquetas, y expande la selección progresivamente al nodo padre si sigues repitiendo.
--
-- **Uso típico:** estás dentro de una función y quieres seleccionar rápido todo el bloque `if`, o todo el cuerpo de la función, sin contar líneas ni usar `%`.
--
-- ## `r` (solo operator-pending) → `require('flash').remote()`
--
-- Te deja ejecutar un operador (como `d`, `y`, `c`) sobre un lugar remoto **sin mover el cursor hacia allá**. Es como un "teleport" temporal para el operador.
--
-- **Ejemplo:** `yr` + `fu` + label copia el texto en ese punto remoto y tu cursor se queda donde estaba.
--
-- ## `R` (visual, operator-pending) → `require('flash').treesitter_search()`
--
-- Combina búsqueda de Flash con selección basada en Treesitter — busca coincidencias de texto pero selecciona el nodo sintáctico completo que las contiene, en vez de solo el texto.
--
-- ## `<c-s>` en modo `:` (Cmdline) → `require('flash').toggle()`
--
-- Actúa dentro de una búsqueda normal de Vim (`/patrón` o `?patrón`). Mientras escribes la búsqueda, presionar `Ctrl+S` activa las etiquetas de Flash sobre las coincidencias visibles, para saltar directo a una en vez de recorrerlas con `n`/`N`.
--
-- ---
--
-- **En resumen:** `s` y `S` son para saltar rápido (por texto o por sintaxis), `r` para operar remotamente sin moverte, `R` mezcla ambos, y `<c-s>` mejora la búsqueda nativa de Vim. El más usado en el día a día es `s`.
--
-- ¿Quieres que arme un ejemplo práctico paso a paso con un archivo de código para probar `s` y `S`?
