local M = {}

local function ziggity_path()
  return vim.fn.expand("~/.local/bin/ziggity")
end
--
-- function M.run_in_ghostty(cmd)
--   local wrapped = string.format(
--   -- sleep en esta linea, es para mostrar en el caso de que exista un error
--   --  - se puede quitar la parte del sleep para que se cierre en automatico
--     [[%s; ec=$?; if [ $ec -ne 0 ]; then echo; echo "[ERROR] exit code $ec"; sleep 2; fi; exit $ec]],
--     cmd
--   )
--   vim.fn.jobstart({ "ghostty", "-e", "sh", "-c", wrapped }, { detach = true })
-- end
--
-- function M.run_ziggity()
--   local bin = ziggity_path()
--   if vim.fn.executable(bin) ~= 1 then
--     vim.notify("ziggity no encontrado o no ejecutable en " .. bin, vim.log.levels.ERROR)
--     return
--   end
--   -- Ejecuta ziggity en el cwd actual del buffer
--   local cmd = string.format("cd %s && %s", vim.fn.shellescape(vim.fn.getcwd()), bin)
--   M.run_in_ghostty(cmd)
-- end
--
-- vim.keymap.set("n", "<leader>z", M.run_ziggity, { desc = "Run ziggity (ghostty)" })



function M.run_in_kitty(cmd)
  local wrapped = string.format(
    [[%s; ec=$?; if [ $ec -ne 0 ]; then echo; echo "[ERROR] exit code $ec"; sleep 2; fi; exit $ec]],
    cmd
  )
  vim.fn.jobstart({ "kitty", "sh", "-c", wrapped }, { detach = true })
end

--
-- function M.run_in_kitty(cmd)
--   local wrapped = string.format(
--     [[%s; ec=$?; if [ $ec -eq 0 ]; then echo; echo "[OK] Presiona una tecla para cerrar..."; read -n 1 -s; else echo; echo "[ERROR] exit code $ec - presiona una tecla para cerrar..."; read -n 1 -s; fi; exit $ec]],
--     cmd
--   )
--   vim.fn.jobstart({ "kitty", "sh", "-c", wrapped }, { detach = true })
-- end
--
function M.run_ziggity()
  local bin = ziggity_path()
  if vim.fn.executable(bin) ~= 1 then
    vim.notify("ziggity no encontrado o no ejecutable en " .. bin, vim.log.levels.ERROR)
    return
  end
  -- Ejecuta ziggity en el cwd actual del buffer
  local cmd = string.format("cd %s && %s", vim.fn.shellescape(vim.fn.getcwd()), bin)
  M.run_in_kitty(cmd)
end

vim.keymap.set("n", "<leader>z", M.run_ziggity, { desc = "Run ziggity (kitty)" })

return M
