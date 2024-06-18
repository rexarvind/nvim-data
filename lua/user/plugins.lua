local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  git = {
    clone_timeout = 300, -- Timeout, in seconds, for git clones
  },
}

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use { "wbthomason/packer.nvim" } -- Have packer manage itself
    use { "nvim-lua/plenary.nvim" } -- Useful lua functions used by lots of plugins

    -- Improve load time 
    use { "lewis6991/impatient.nvim" }

    -- comments, autopairs, file explorer, bufferline(file tabs), status line
    use { "numToStr/Comment.nvim" }
    use { "JoosepAlviste/nvim-ts-context-commentstring" }
    use { "windwp/nvim-autopairs" } -- Autopairs, integrates with both cmp and treesitter
    use { "kyazdani42/nvim-tree.lua" }
    use { "akinsho/bufferline.nvim" }
    use { "moll/vim-bbye" }
    use { "nvim-lualine/lualine.nvim" }
    use { "mg979/vim-visual-multi", branch = "master" } -- use multicusors

    -- project management, icons indent blankline
    -- use { "ahmedkhalf/project.nvim" }
    use { "kyazdani42/nvim-web-devicons" }
    -- use { "lukas-reineke/indent-blankline.nvim" }

    -- start screen
    -- use { "goolord/alpha-nvim" }
    -- use { "glepnir/dashboard-nvim" }

    -- colorschemes
    use { "lunarvim/darkplus.nvim" }

    -- emmet for html and css 
    use { "mattn/emmet-vim",
            setup = function ()
                vim.g.user_emmet_leader_key = '<A-,>'
            end
        }

    -- completions plugins
    use { "hrsh7th/nvim-cmp" } -- The completion plugin
    use { "hrsh7th/cmp-buffer" } -- buffer completions
    use { "hrsh7th/cmp-path" } -- path completions
    use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }

    -- snippets
    use { "L3MON4D3/LuaSnip" } --snippet engine
    use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use

    -- LSP
    use { "williamboman/nvim-lsp-installer" } -- simple to use language server installer
    use { "neovim/nvim-lspconfig" } -- enable LSP
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    -- use { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" } -- for formatters and linters
    use { "RRethy/vim-illuminate" } -- highlight other uses of word under cursor

    -- Telescope
    use { "nvim-telescope/telescope.nvim" }

    -- Treesitter
    use { "nvim-treesitter/nvim-treesitter" }

    -- Git
    use { "lewis6991/gitsigns.nvim" }

    -- DAP
    -- use { "mfussenegger/nvim-dap", commit = "6b12294a57001d994022df8acbe2ef7327d30587" }
    -- use { "rcarriga/nvim-dap-ui", commit = "1cd4764221c91686dcf4d6b62d7a7b2d112e0b13" }
    -- use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

    -- extra plugins
    -- use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)


