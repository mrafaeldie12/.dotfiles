local leader = " "

vim.g.mapleader = leader
vim.g.maplocalleader = leader

require('packer').startup(function() 
    use 'wbthomason/packer.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use 'neovim/nvim-lspconfig'
    use 'tridactyl/vim-tridactyl'
    use 'mbbill/undotree'
    use 'direnv/direnv'
    use 'tpope/vim-commentary'
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-fugitive'
    use 'junegunn/fzf.vim'
    use 'godlygeek/tabular'
    use 'preservim/vim-markdown'
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
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

set_key = vim.keymap.set

set_key("i", "jk", "<Esc>")
set_key("i", "<Esc>", "<nop>")

set_key("i", "<Up>", "<nop>")
set_key("i", "<Down>", "<nop>")
set_key("t", "<Esc>", "<C-\\><C-n>")
set_key("t", "<A-h>", "<C-\\><C-N><C-w>h")
set_key("t", "<A-j>", "<C-\\><C-N><C-w>j")
set_key("t", "<A-k>", "<C-\\><C-N><C-w>k")
set_key("t", "<A-l>", "<C-\\><C-N><C-w>l")
set_key("t", "<A-h>", "<C-\\><C-N><C-w>h")
set_key("t", "<A-j>", "<C-\\><C-N><C-w>j")
set_key("t", "<A-k>", "<C-\\><C-N><C-w>k")
set_key("t", "<A-l>", "<C-\\><C-N><C-w>l")
set_key("i", "<A-h>", "<C-w>h")
set_key("i", "<A-j>", "<C-w>j")
set_key("i", "<A-k>", "<C-w>k")
set_key("i", "<A-l>", "<C-w>l")

arrow_keys = {"<Up>", "<Down>", "<Left>", "<Right>"}

for _, value in pairs(arrow_keys) do
	set_key({"n", "v"}, value, "<nop>")
end

local lsp = require("lspconfig")
local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

require('mini.surround').setup({})
require('nvim-autopairs').setup({})

set_key("n", "<leader>h", ":noh<CR>")

function hide_line_number()
    vim.o.relativenumber = false
    vim.o.number = false
end

function toggle_relative_number()
    vim.o.relativenumber = true
    vim.o.number = true
end

function normal_line_numbers()
    vim.o.relativenumber = false
    vim.o.number = true
end

set_key("n", "<leader>trn", toggle_relative_number, {})
set_key("n", "<leader>tn", normal_line_numbers, {})
set_key("n", "<leader>tnn", hide_line_number, {})

set_key("n", "<leader>ut", ":UndotreeToggle<CR>")

set_key("n", "<leader>gy", ":Goyo<CR>")

local on_attach = function(client, bufnr)
	local opts = { noremap = true,
	               silent  = true,
	               buffer = bufnr }

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	set_key("n", "gd", vim.lsp.buf.definition, opts)
	set_key("n", "gr", vim.lsp.buf.references, opts)
	set_key("n", "gi", vim.lsp.buf.implementation, opts)
	set_key("n", "gt", vim.lsp.buf.type_definition, opts)
	set_key("n", "K", vim.lsp.buf.hover, opts)
	set_key("n", "<leader>rn", vim.lsp.buf.rename, opts)
    set_key('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    set_key('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
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

local telescope = require('telescope.builtin')

set_key('n', '<leader>ff', telescope.find_files, {})
set_key('n', '<leader>fg', telescope.live_grep, {})
set_key('n', '<leader>fb', telescope.buffers, {})
set_key('n', '<leader>fh', telescope.help_tags, {})

o = vim.o

o.termguicolors = true
o.incsearch = true
o.scrolloff = 1
o.autoread = true
o.background = "dark"
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.number = true
o.relativenumber = true
o.cmdheight = 0
o.laststatus = 3
o.syntax = enable
-- Set split preferences
o.splitbelow = true
o.splitright = true

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

