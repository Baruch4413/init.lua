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
  'michaeljsmith/vim-indent-object',
  'tomtom/tcomment_vim',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'wellle/targets.vim',
  'kyazdani42/nvim-web-devicons',
  'akinsho/bufferline.nvim',
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
  'baruchespinoza/config.vim',
  {
    "rockyzhang24/arctic.nvim",
    branch = "v2",
    dependencies = { "rktjmp/lush.nvim" }
  }
}, opts)

vim.cmd("colorscheme arctic")
