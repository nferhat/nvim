local C = require "ui.theme.colors"

return {
    TelescopeNormal = { fg = C.foreground, bg = "none" },
    TelescopeBorder = { fg = C.border, bg = "none" },

    TelescopeSelection = { bg = C.light_background, fg = C.color4, bold = true },
    TelescopeSelectionCaret = { bg = C.selection, fg = C.color4 },
    TelescopeMatching = { fg = C.color6, bold = true, italic = true },

    TelescopeMultiIcon = { fg = C.color1, bold = true },
    TelescopeMultiSelection = { fg = C.color3, bold = true },
    TelescopePromptCounter = C.comment,
    TelescopePreviewMessageFillchar = C.comment,
    TelescopePreviewMessage = { fg = C.color7, bold = true },
}
