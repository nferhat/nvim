local M = {}

M.highlight_text = function(highlight, text)
    return string.format("%%#%s#%s", highlight, text)
end

M.lazy_load = function(plugin)
    vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
        group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
        callback = function()
            local file = vim.fn.expand "%"
            if not (file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= "") then
                return
            end

            vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)
            -- Dont defer for treesitter as it will show slow highlighting
            -- This deferring only happens only when we do "nvim filename"
            if plugin == "nvim-treesitter" then
                return require("lazy").load { plugins = plugin }
            end

            vim.schedule(function()
                require("lazy").load { plugins = plugin }
                if plugin == "nvim-lspconfig" then
                    -- For LSP events to trigger, since lspconfig have some FileType autocmds.
                    vim.cmd "silent! do FileType"
                end
            end)
        end,
    })
end

M.lazy_load_insert_enter = function(plugin)
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
        callback = function(event)
            if vim.bo[event.buf].buftype == "prompt" then
                return
            end

            vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)
            vim.schedule(function()
                require("lazy").load { plugins = plugin }
            end)
        end,
    })
end

return M
