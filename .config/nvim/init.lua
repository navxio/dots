local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.opt.termguicolors = true

vim.o.background = 'dark'
vim.g.mapleader = ' '

return require('packer').startup(function(use)

  use {'akinsho/bufferline.nvim', requires='kyazdani42/nvim-web-devicons'}
  use 'wbthomason/packer.nvim'

  use 'svermeulen/vimpeccable'

  use 'jeffkreeftmeijer/neovim-sensible'
  use 'kyazdani42/nvim-web-devicons'

  use {'adisen99/apprentice.nvim', requires = {'rktjmp/lush.nvim'}}

  use 'machakann/vim-sandwich'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }}
  }

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
            'nvim-lua/plenary.nvim'
    },
  }

  use {
    'kyazdani42/nvim-tree.lua',
    config = function () require'nvim-tree'.setup {} end
  }
  use 'feline-nvim/feline.nvim'

  use 'steelsojka/pears.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  require'feline'.setup()

  require('lush')(require('apprentice').setup({
    plugins = {
      'gitsigns',
      'cmp', -- nvim-cmp
      'lsp',
      'lspsaga',
      'packer',
      'signify',
      'telescope',
      'treesitter'
  },
  langs = {
    'c',
    'rust',
    'html',
    'golang',
    'css',
    'js',
    'markdown',
    'python',
    'typescript',
    'ocaml',
    'jsx',
    'json',
    'ruby'
  }

}))

require('bufferline').setup{}

require('pears').setup()

-- vimpeccable keybindings
local vimp = require('vimp')

vimp.nnoremap('<leader>ev', ':e ~/.config/nvim/init.lua<cr>')
vimp.nnoremap('<leader>n', ':NvimTreeToggle<cr>')
vimp.nnoremap('<leader>s', ':w<cr>')
vimp.nnoremap('<leader>ff', ':Telescope find_files<CR>')

end)
