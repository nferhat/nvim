local M = {}

local function save_skeleton(name, highlights)
    -- Convert the skeleton highlights to an string that gets dumpted to lua bytecode
    local highlights_as_string = ""

    for hl, data in pairs(highlights) do
        if data.HEX then
            highlights_as_string = highlights_as_string
                .. "vim.api.nvim_set_hl(0,'"
                .. hl
                .. "',{fg='"
                .. data:HEX(true)
                .. "'});"
        else
            local opts = ""
            for k, v in pairs(data) do
                local ret
                if type(v) == "table" and v.HEX then
                    ret = "'" .. v:HEX(true) .. "'"
                elseif type(v) == "boolean" or type(v) == "number" then
                    ret = tostring(v)
                elseif type(v) == "string" then
                    ret = "'" .. v .. "'"
                end
                opts = opts .. k .. "=" .. ret .. ","
            end

            highlights_as_string = highlights_as_string .. "vim.api.nvim_set_hl(0,'" .. hl .. "',{" .. opts .. "});"
        end
    end

    local data = loadstring("return string.dump(function()" .. highlights_as_string .. "end)")()
    local file = io.open(_G.theme_cache_path .. name, "wb")

    if file and data then
        file:write(data)
        file:close()
        print("Compiled skeleton: " .. name)
    end
end

function M.load_skeleton(name)
    if vim.fn.file_readable(_G.theme_cache_path .. name) == 0 then
        local ok, highlights = pcall(require, "ui.theme.skeletons." .. name)
        if not ok then
            return vim.notify("No skeleton named: " .. name, vim.log.levels.ERROR)
        end
        save_skeleton(name, highlights)
    end

    dofile(_G.theme_cache_path .. name)
end

function M.init()
    _G.theme_cache_path = vim.fn.stdpath "cache" .. "/theme/"

    local skeletons_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h") .. "/skeletons/"

    if not vim.loop.fs_stat(_G.theme_cache_path) then
        vim.fn.mkdir(_G.theme_cache_path, "p")

        for _, file in ipairs(vim.fn.readdir(skeletons_path)) do
            local filename = vim.fn.fnamemodify(file, ":r")
            local data = require("ui.theme.skeletons." .. filename)
            save_skeleton(filename, data)
        end
    end

    vim.api.nvim_create_user_command("RecompileSkeletons", function()
        vim.fn.delete(_G.theme_cache_path, "rf")
        vim.fn.mkdir(_G.theme_cache_path, "p")

        require("plenary.reload").reload_module "ui.theme.skeletons"
        require("plenary.reload").reload_module "ui.theme.colors"

        for _, file in ipairs(vim.fn.readdir(skeletons_path)) do
            local filename = vim.fn.fnamemodify(file, ":r")
            local data = require("ui.theme.skeletons." .. filename)
            save_skeleton(filename, data)
            M.load_skeleton(filename)
        end
    end, {})

    M.load_skeleton "base"
end

return M
