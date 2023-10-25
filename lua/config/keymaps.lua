-- Overriding the vim.keymap.set function to enforce default settings.
-- Yes, I do know it's a bad idea to override core functions, but there isn't
-- a builtin way to set default options.
vim.keymap.set_backup = vim.keymap.set
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
function vim.keymap.set(mode, lhs, rhs, opts) ---@diagnostic disable-line
    opts = opts or {}
    opts.silent = opts.silent ~= nil and opts.silent or true -- Why isn't this a default?
    vim.keymap.set_backup(mode, lhs, rhs, opts)
end

local set_keymap = vim.keymap.set

vim.g.mapleader = " "
set_keymap({ "n", "v", "o" }, "<Space>", "<nop>")

-- Window navigation made easier.
set_keymap("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
set_keymap("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
set_keymap("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
set_keymap("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- Terminal window navigation
set_keymap("t", "<C-x>", "<C-\\><C-N><Esc>", { desc = "Exit Terminal insert" })
set_keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Window Left" })
set_keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Window Down" })
set_keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Window Up" })
set_keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Window Right" })

-- Buffer actions
set_keymap("n", "<leader>x", ":Bdelete!<CR>", { desc = "Close Buffer" })
set_keymap("n", "<leader>s", ":write!<CR>", { desc = "Save Buffer" })

-- Easier splits
set_keymap("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical Split" })
set_keymap("n", "<leader>-", ":split<CR>", { desc = "Horizontal Split" })

-- Stop matching for patterns
set_keymap("n", "<Esc>", ":nohlsearch<CR>")

-- Allow moving through wrapped lines without using g{j,k}
set_keymap("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
set_keymap("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
set_keymap("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
set_keymap("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })

-- Easier indenting.
set_keymap("n", ">", ">>", { desc = "Indent to the Left" })
set_keymap("n", "<", "<<", { desc = "Indent to the Right" })
set_keymap({ "v", "x" }, "<", "<gv", { desc = "Indent to the Left" })
set_keymap({ "v", "x" }, ">", ">gv", { desc = "Indent to the Right" })

-- Don't put deleted text from x into clipboard.
set_keymap("n", "x", '"_x', { noremap = false })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set_keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
set_keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
set_keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
set_keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
