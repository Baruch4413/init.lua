local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  'michaeljsmith/vim-indent-object',
  'tomtom/tcomment_vim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'wellle/targets.vim',
  'kyazdani42/nvim-web-devicons',
  { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
  'airblade/vim-gitgutter',
  'christoomey/vim-sort-motion',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'nvim-lualine/lualine.nvim',
}, opts)

vim.cmd.colorscheme "catppuccin-macchiato" -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

require("bufferline").setup{
  options = {
    indicator_icon = "☣",
    numbers = "buffer_id",
    number_style = "superscript",
    diagnostics = "nvim_lsp",
    show_buffer_icons = true,
    show_buffer_close_icons = false,
  },
}

require("mason").setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    -- Replace these with whatever servers you want to install
    'tsserver',
    'quick_lint_js',
    'intelephense',
    'html',
    'pyright',
  }
})

local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end,
})

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['tsserver'].setup { capabilities = capabilities }
require('lspconfig')['quick_lint_js'].setup { capabilities = capabilities }
require('lspconfig')['intelephense'].setup { capabilities = capabilities }
require('lspconfig')['html'].setup { capabilities = capabilities }
require('lspconfig')['pyright'].setup { capabilities = capabilities }

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 0
vim.opt_local.expandtab = true
vim.opt_local.mouse = "a"
-- vim.opt_local.complete-="i"
vim.opt_local.sidescroll=1
vim.opt_local.ttimeoutlen=50
vim.opt_local.encoding="utf-8"
vim.opt_local.clipboard="unnamedplus"
vim.opt_local.wildmode="list:full"
vim.opt_local.wildoptions="fuzzy"
vim.opt_local.fileformats="unix,dos,mac"
vim.opt_local.listchars="tab:▒░,trail:∞"
vim.opt_local.backspace="indent,eol,start"
vim.opt_local.completeopt="menuone,longest,preview"
-- vim.keymap.set('n', ':bprevious', '[<C-j>]')
-- vim.keymap.set('n', ':bnext', '[<C-k>]')
vim.cmd([[
set list showmatch showmode shiftround ttimeout hidden showcmd hlsearch smartcase nobackup nowritebackup noswapfile termguicolors cursorline lazyredraw nowrap autoindent smarttab incsearch relativenumber number expandtab
:tnoremap <C-j> :bprevious<CR>
:tnoremap <C-k> :bnext<CR>

:inoremap <C-j> :bprevious<CR>
:inoremap <C-k> :bnext<CR>

:nnoremap <C-j> :bprevious<CR>
:nnoremap <C-k> :bnext<CR>
]])

-- set list showmatch showmode shiftround ttimeout hidden showcmd hlsearch smartcase nobackup nowritebackup noswapfile termguicolors cursorline lazyredraw nowrap autoindent smarttab incsearch relativenumber number expandtab

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.py" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
