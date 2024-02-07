vim.g.mapleader = ","
vim.g.maplocalleader = ","

require('packer').startup(function() 
    use 'wbthomason/packer.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use "ellisonleao/gruvbox.nvim" 
    use "projekt0n/github-nvim-theme"
    use 'neovim/nvim-lspconfig'
    use 'tridactyl/vim-tridactyl'
    use 'mbbill/undotree'
    use 'dracula/vim'
    use 'direnv/direnv'
    use 'tpope/vim-commentary'
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-fugitive'
    use 'junegunn/fzf.vim'
    use 'ferrine/md-img-paste.vim'
    use 'godlygeek/tabular'
    use 'preservim/vim-markdown'
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'drewtempelmeyer/palenight.vim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'mhartington/oceanic-next'
    use 'echasnovski/mini.nvim'
    use 'L3MON4D3/LuaSnip'
    use {
        'junegunn/fzf',
        run = 'fzf#install()',
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}
        }
    }
end)

vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "<Esc>", "<nop>")

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<A-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<A-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<A-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<A-j>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<A-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<A-l>", "<C-\\><C-N><C-w>l")
vim.keymap.set("i", "<A-h>", "<C-w>h")
vim.keymap.set("i", "<A-j>", "<C-w>j")
vim.keymap.set("i", "<A-k>", "<C-w>k")
vim.keymap.set("i", "<A-l>", "<C-w>l")

arrowKeys = {"<Up>", "<Down>", "<Left>", "<Right>"}

for key, value in pairs(arrowKeys) do
	vim.keymap.set({"n", "v"}, value, "<nop>")
end

local lsp = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

require('mini.surround').setup({})
require('nvim-autopairs').setup({})

vim.keymap.set("n", "<leader>h", ":noh<CR>")
vim.keymap.set("n", "<leader>tn", ":set rnu!<CR>")

vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>")

vim.keymap.set("n", "<leader>gy", ":Goyo<CR>")

local on_attach = function(client, bufnr)
	local opts = { noremap = true,
	               silent  = true,
	               buffer = bufnr }

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.gopls.setup({
	name = "gopls",
	cmd = {"gopls", "--remote=auto", "serve"},
	init_options = {
		gofumpt = true,
		staticcheck = true,
		memoryMode = "DegradeClosed"
	},
	whitelist = {"go"},
	capabilities = capabilities,
	on_attach = on_attach
})

lsp.pyright.setup({
	on_attach = on_attach,
    capabilities = capabilities
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	preselect = cmp.PreselectMode.None,
	mapping = cmp.mapping.preset.insert({
              ['<c-b>'] = cmp.mapping.scroll_docs(-4),
              ['<c-f>'] = cmp.mapping.scroll_docs(4),
              ['<tab>'] = cmp.mapping.select_next_item(),
              ['<s-tab>'] = cmp.mapping.select_prev_item(),
              ['<c-space>'] = cmp.mapping.complete(),
              ['<c-e>'] = cmp.mapping.abort(),
              ['<cr>'] = cmp.mapping.confirm({select  = true})
        }),
        sources = cmp.config.sources({
              {name = "nvim_lsp"}
	})
})

function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")


vim.o.termguicolors = true
vim.o.incsearch = true
vim.o.scrolloff = 1
vim.o.autoread = true
vim.o.background = "dark"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.syntax = enable
vim.cmd.colorscheme "catppuccin-mocha"

-- Enable syntax highlighting
vim.cmd('syntax enable')

-- Auto commands for Goyo
vim.api.nvim_create_autocmd("User", {
    pattern = "GoyoEnter",
    command = "Limelight"
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GoyoLeave",
    command = "Limelight!"
})

-- Enable filetype plugins and indenting
vim.cmd('filetype plugin indent on')

-- Autogroup for templates with automatic loading for Go files
vim.api.nvim_create_augroup("templates", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
    group = "templates",
    pattern = "*.go",
    command = "0r ~/.dotfiles/nvim/templates/main.go"
})

-- Auto command for organizing Go imports before saving
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        OrgImports(1000)
    end,
})

-- Set split preferences
vim.o.splitbelow = true
vim.o.splitright = true
