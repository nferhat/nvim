-- Disable checking for language providers.
local providers = { "python", "node", "ruby", "perl" }
for _, provider in pairs(providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

require "config.options"
require "config.keymaps"
require "config.autocommands"
