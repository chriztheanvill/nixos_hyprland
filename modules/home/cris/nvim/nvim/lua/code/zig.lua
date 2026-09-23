-- Indicar a Neovim que use el compilador nativo de zig
-- vim.cmd('compiler zig')

-- -- .tasks.lua
-- return {
--   {
--     name = "Build",
--     cmd = "zig build",
--   },
--   {
--     name = "Build (Debug) LLVM and LLD",
--     cmd = "zig build -Ddebugger=true",
--   },
--   {
--     name = "Build (ReleaseFast)",
--     cmd = "zig build --release=fast",
--   },
--   {
--     name = "Build (ReleaseFast Debuggable)",
--     cmd = "zig build --release=fast -Ddebugger=true",
--   },
--   {
--     name = "Run",
--     cmd = "zig build run",
--   },
--   {
--     name = "Test",
--     cmd = "zig build test",
--   },
-- }

local M = {}

local function find_tasks_file()
  local cwd = vim.fn.getcwd()
  local path = cwd .. "/.tasks.lua"
  if vim.fn.filereadable(path) == 1 then
    return path
  end
  return nil
end

function M.run_task()
  local path = find_tasks_file()
  if not path then
    vim.notify("No se encontró .tasks.lua en " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end

  local ok, tasks = pcall(dofile, path)
  if not ok or type(tasks) ~= "table" then
    vim.notify("Error cargando .tasks.lua", vim.log.levels.ERROR)
    return
  end

  local names = {}
  for _, t in ipairs(tasks) do
    table.insert(names, t.name)
  end

  vim.ui.select(names, { prompt = "Selecciona una task:" }, function(choice, idx)
    if not choice then
      return
    end
    local task = tasks[idx]
    -- M.run_in_ghostty(task.cmd)
    M.run_in_kitty(task.cmd)
  end)
end

-- Cierra automáticamente solo si el comando termina con éxito (exit code 0).
-- Si falla, se queda abierta para que veas el error.
function M.run_in_kitty(cmd)
  local wrapped = string.format(
    [[%s; ec=$?; if [ $ec -eq 0 ]; then echo; echo "[OK] Presiona una tecla para cerrar..."; read -n 1 -s; else echo; echo "[ERROR] exit code $ec - presiona una tecla para cerrar..."; read -n 1 -s; fi; exit $ec]],
    cmd
  )

  vim.fn.jobstart({ "kitty", "sh", "-c", wrapped }, { detach = true })
end

--
-- Ghostty aun no, esta en beta
function M.run_in_ghostty(cmd)
  local wrapped = string.format(
    [[%s; ec=$?; if [ $ec -eq 0 ]; then echo; echo "[OK] Presiona una tecla para cerrar..."; read -n 1 -s; else echo; echo "[ERROR] exit code $ec - presiona una tecla para cerrar..."; read -n 1 -s; fi; exit $ec]],
    cmd
  )
  vim.fn.jobstart({ "ghostty", "-e", "sh", "-c", wrapped }, { detach = true })
end

vim.keymap.set("n", "<leader>t", M.run_task, { desc = "Run Task (ghostty)" })

return M

-- ## 1. `zig build`
--
-- - **Optimización**: `Debug` (tu `preferred_optimize_mode`)
-- - **Backend**: `use_llvm=false`, `use_lld=false` (backend nativo x86_64)
-- - **Resultado**: compilación **más rápida posible**, binario sin optimizar, sin símbolos completos de debug
-- - **Uso**: iteración diaria normal — escribes código, corriges un bug de lógica, pruebas un cambio visual, revisas que compile. El 90% de tu tiempo de desarrollo debería vivir aquí.
-- - **Ejemplo**: "agregué una nueva pieza al Tetris, quiero ver rápido si aparece en pantalla y se mueve bien" → `zig build run`
--
-- ## 2. `zig build -Ddebugger=true`
--
-- - **Optimización**: `Debug` (sigue siendo Debug, solo cambia el backend)
-- - **Backend**: `use_llvm=true`, `use_lld=true`
-- - **Resultado**: compilación más lenta, binario sin optimizar pero con **símbolos DWARF completos** — LLDB/GDB pueden mostrarte todas las variables, structs, punteros, etc.
-- - **Uso**: cuando tienes un bug que no puedes entender solo leyendo el código y necesitas poner breakpoints e inspeccionar el estado real — un crash raro, un valor que no cuadra, un comportamiento inesperado en la física de colisión de tus piezas.
-- - **Ejemplo**: "el Tetris se crashea al rotar una pieza cerca del borde, pero no sé por qué" → pones breakpoint en la función de rotación, corres con este perfil, inspeccionas `piece.x`, `piece.rotation_state`, etc.
--
-- ## 3. `zig build --release=fast`
--
-- - **Optimización**: `ReleaseFast` (optimizaciones agresivas del compilador, sin safety checks de Zig como overflow/bounds en release)
-- - **Backend**: en release, Zig normalmente **fuerza LLVM de todos modos** para poder aplicar las optimizaciones (el backend nativo no tiene el mismo nivel de optimización que LLVM), así que aunque no pusiste `-Ddebugger=true`, probablemente el compilador use LLVM aquí igual — pero sin símbolos de debug completos ni `-g` útil, porque el objetivo es rendimiento, no depuración.
-- - **Resultado**: binario rápido en ejecución, sin protecciones de debug, compilación de este perfil más lenta que el perfil 1 (por las optimizaciones), pero el binario final corre mucho mejor.
-- - **Uso**: cuando quieres medir rendimiento real (FPS, tiempos de frame) o vas a compartir/distribuir un build jugable a alguien más.
-- - **Ejemplo**: "quiero ver si mi sistema de renderizado realmente corre a 60fps estable, sin el overhead de los safety checks de Debug" → `zig build run --release=fast`
--
-- ## 4. `zig build --release=fast -Ddebugger=true`
--
-- - **Optimización**: `ReleaseFast`
-- - **Backend**: forzado explícitamente a LLVM+LLD (aunque como dije, probablemente ya lo era)
-- - **Resultado**: binario optimizado para rendimiento, **pero con símbolos de debug disponibles** — te deja perfilar/depurar un build que se comporta como el de producción, en vez de depurar solo la versión lenta sin optimizar.
-- - **Uso**: el caso clásico es un bug que **solo aparece con optimizaciones activas** (muy común: undefined behavior que Debug detecta/previene pero ReleaseFast no, race conditions que cambian de timing, o simplemente quieres perfilar con un profiler que necesita símbolos pero código optimizado real).
-- - **Ejemplo**: "en Debug todo funciona bien, pero en ReleaseFast el juego se comporta raro o se crashea — necesito meter un breakpoint en el build optimizado para ver qué está pasando exactamente ahí".
--
-- ## Nombre recomendado para la task #4
--
-- Como es específicamente para depurar un problema que solo ocurre en release, yo le pondría algo que deje claro que es un caso especial, no tu debug normal:
--
-- ```lua
-- {
--   name = "Build (Release + Debug Symbols)",
--   cmd = "zig build --release=fast -Ddebugger=true",
-- },
-- ```
--
-- o si prefieres más corto y técnico:
--
-- ```lua
-- {
--   name = "Build (ReleaseFast Debuggable)",
--   cmd = "zig build --release=fast -Ddebugger=true",
-- },
-- ```
--
-- Evita llamarlo solo "Debug Release" (es ambiguo, suena contradictorio) — mejor que el nombre deje claro que es release **con** símbolos, para que no lo confundas con tu perfil normal de debug (#2) cuando estés eligiendo la task rápido.
