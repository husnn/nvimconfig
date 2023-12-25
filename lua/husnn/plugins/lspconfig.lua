local servers = {
  astro = {
    typescript = {}
  },
  cssls = {},
  html = {},
  lua_ls = {
    diagnostics = { globals = { "vim" } }
  },
  pyright = {},
  tailwindcss = {},
  tsserver = {}
}

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp'
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lspconfig = require('lspconfig')

    local on_attach = function(_, bufnr)
      local keymap = vim.keymap

      local nmap = function(lhs, rhs, desc)
        keymap.set('n', lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')

      nmap('gd', '<cmd>Telescope lsp_definitions<CR>', 'Go to definitions')
      nmap('gi', '<cmd>Telescope lsp_implementations<CR>', 'Go to implementations')
      nmap('gr', '<cmd>Telescope lsp_references<CR>', 'Go to references')

      keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
      keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })

      keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
      keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', { desc = 'Show buffer diagnostics' })

      keymap.set('n', '<leader>rs', ':LspRestart<CR>', { desc = 'Restart language server' })

      keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Show code actions' })
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    for name, opts in pairs(servers) do
      lspconfig[name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = opts,
        filetypes = (opts or {}).filetypes
      }
    end
  end
}

