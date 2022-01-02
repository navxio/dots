local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.api.nvim_command('set termguicolors')

return require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  use 'wbthomason/packer.nvim'

  use 'jeffkreeftmeijer/neovim-sensible'
  use 'kyazdani42/nvim-web-devicons'

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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  require'feline'.setup()
end)

