local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.g.mapleader = ' '

-- setup lazygit
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = 'lazygit',
  direction = 'float',
  hidden = true })

function _lazygit_toggle ()
  lazygit:toggle()
end

return require('packer').startup(function(use)

  use {'akinsho/bufferline.nvim', requires='kyazdani42/nvim-web-devicons'}
  use 'wbthomason/packer.nvim'

  use {'datwaft/bubbly.nvim', config = function ()
    vim.g.bubbly_palette = {
      background = "#34343c",
      foreground = "#c5cdd9",
      black = "#3e4249",
      red = "#ec7279",
      green = "#a0c980",
      yellow = "#deb974",
      blue = "#6cb6eb",
      purple = "#d38aea",
      cyan = "#5dbbc1",
      white = "#c5cdd9",
      lightgrey = "#57595e",
      darkgrey = "#404247",
    }
    vim.g.bubbly_statusline = {
      'mode',

      'truncate',

      'path',
      'branch',
      'gitsigns',

      'divisor',
      'filetype',
      'progress'
    }
  end}

  use 'svermeulen/vimpeccable'

  use 'jeffkreeftmeijer/neovim-sensible'
  use 'kyazdani42/nvim-web-devicons'

  use {'adisen99/apprentice.nvim', requires = {'rktjmp/lush.nvim'}}

  use 'machakann/vim-sandwich'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{ 'nvim-lua/plenary.nvim' }}
  }

  use 'akinsho/toggleterm.nvim'


  use {
    'nvim-treesitter/nvim-treesitter'
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
            'nvim-lua/plenary.nvim'
    },
  }

  use 'terrortylor/nvim-comment'

  use 'karb94/neoscroll.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    config = function () require'nvim-tree'.setup {} end
  }

  use 'steelsojka/pears.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  -- require'feline'.setup()

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

  require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    sync_install = false,
    ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false
    }
  }

  require('nvim_comment').setup()

  require('neoscroll').setup()

  -- vimpeccable keybindings
  local vimp = require('vimp')

  vimp.nnoremap('<leader>rc', ':e ~/.config/nvim/init.lua<cr>')
  vimp.nnoremap('<c-n>', ':NvimTreeToggle<cr>')
  vimp.nnoremap('<c-s>', ':w<cr>')
  vimp.nnoremap('<leader>e', ':q!<cr>')
  vimp.nnoremap('<c-p>', ':Telescope find_files<CR>')

  vim.api.nvim_set_keymap('n', '<c-g>', "<cmd>lua _lazygit_toggle()<CR>",
  {noremap = true, silent = true })

  vim.g.bubbly_tabline = 0

end)

