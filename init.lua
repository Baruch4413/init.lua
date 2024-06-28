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
  { 'nvim-treesitter/nvim-treesitter'},
  'airblade/vim-gitgutter',
  'christoomey/vim-sort-motion',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/nvim-cmp',
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
    'phpactor',
    'pyright',
    'vtsls',
    'lua_ls',
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['phpactor'].setup { capabilities = capabilities }
require('lspconfig')['pyright'].setup { capabilities = capabilities }
require('lspconfig')['vtsls'].setup { capabilities = capabilities }
-- require('lspconfig')['lua-language-server'].setup { capabilities = capabilities }
require'lspconfig'.lua_ls.setup{}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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

local cmp = require'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
    },
    {
      { name = 'buffer' },
    }
  )
})

vim.cmd([[
  tnoremap <Esc> <C-\><C-n>

  if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
  endif

  :tnoremap <C-j> :bprevious<CR>
  :tnoremap <C-k> :bnext<CR>

  :inoremap <C-j> :bprevious<CR>
  :inoremap <C-k> :bnext<CR>

  :nnoremap <C-j> :bprevious<CR>
  :nnoremap <C-k> :bnext<CR>
]])

vim.o.mouse = "a"
vim.o.nowrap = false
vim.o.ttimeoutlen = 50
vim.o.encoding = "utf-8"
vim.o.clipboard = "unnamedplus"
vim.o.wildmode = "list:longest"
vim.o.fileformats = "unix,dos,mac"
vim.o.listchars = "tab:▒░,trail:∞"
vim.o.backspace = "indent,eol,start"
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.showmode = true
vim.o.shiftround = true
vim.o.ttimeout = true
vim.o.hidden = true
vim.o.showcmd = true
vim.o.hlsearch = true
vim.o.smartcase = true
vim.o.nobackup = true
vim.o.nowritebackup = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.lazyredraw = true
vim.o.autoindent = true
vim.o.smarttab = true
vim.o.incsearch = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.list = true
vim.o.swapfile = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.py" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "typescript", "tsx", "python", "php" },
  indent = {
    enable = true,
  },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = { "python" },
    additional_vim_regex_highlighting = true,
  },
}
