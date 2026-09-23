require('rooter').setup({
  root_patterns = { '.git/', 'build.zig', 'project.godot' },
  outermost = true,
  enable_cache = true,
  project_non_root = '',
  command = 'lcd',
  exclude_patterns = {
    '%[denite%]',
    'denite%-filter',
    '%[defx%]',
    '^git://',     -- git.vim
    '^neo%-tree',  -- neo-tree.nvim
    '^NvimTree_',  -- nvim-tree.nvim
    '^__Tagbar__', -- tagbar.vim
  },
})
