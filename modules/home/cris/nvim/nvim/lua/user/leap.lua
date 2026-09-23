local leap = require('leap')
leap.opts.preview = true
leap.opts.offset_labels = true

-- f/t enhanced
do
  local function ft(kwargs)
    require('leap').leap(
      vim.tbl_deep_extend('keep', kwargs, {
        inputlen = 1,
        inclusive = true,
        opts = {
          labels = '',
          safe_labels = vim.fn.mode(1):match('no?') and '' or nil,
        },
      })
    )
  end
  local clever = require('leap.user').with_traversal_keys
  local clever_f, clever_t = clever('f', 'F'), clever('t', 'T')
  vim.keymap.set({ 'n', 'x', 'o' }, 'f', function() ft { opts = clever_f } end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'F', function() ft { backward = true, opts = clever_f } end)
  vim.keymap.set({ 'n', 'x', 'o' }, 't', function() ft { offset = -1, opts = clever_t } end)
  vim.keymap.set({ 'n', 'x', 'o' }, 'T', function() ft { backward = true, offset = 1, opts = clever_t } end)
end

-- Jump
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- Visit (remote operations)
vim.keymap.set({ 'n', 'o' }, 'gs', '<Plug>(leap-visit)')
vim.keymap.set({ 'n', 'o' }, 'gS', '<Plug>(leap-visit-linewise)')
vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-visit-text-object)')
vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-visit-inner-text-object)')
vim.keymap.set({ 'o' }, 'rr', '<Plug>(leap-visit-line)')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VisitDone',
  group = vim.api.nvim_create_augroup('VisitorMode', {}),
  callback = function(event)
    if vim.v.operator == 'y' and event.data.register == '"' then
      vim.cmd('normal! p')
    end
  end,
})

-- Treeselect
-- Tip: If you have set up remote text objects (`ar`/`ir`), `arn` will
-- work as expected (visit node).
-- vim.keymap.set({ 'x', 'o' }, 'an', function()
--   require('leap.treesitter').select {
--     opts = require('leap.user').with_traversal_keys('n', 'N')
--   }
-- end)
