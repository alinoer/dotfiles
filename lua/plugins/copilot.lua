return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default tab mapping
      vim.g.copilot_no_tab_map = true
      
      -- Set up keymaps
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      
      -- Additional keymaps for navigation
      vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')
      vim.keymap.set('i', '<C-H>', '<Plug>(copilot-previous)')
      vim.keymap.set('i', '<C-K>', '<Plug>(copilot-next)')
      
      -- Dismiss suggestion
      vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)')
    end,
  },
}