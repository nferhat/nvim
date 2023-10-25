local C = require "ui.theme.colors"

return {
    CmpItemSelected = { bg = C.selection },
    -- Client item kinds, the following are builtin to cmp.
    CmpItemAbbrDeprecated = { fg = C.color7, strikethrough = true },
    CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
    CmpItemAbbrMatch = { fg = C.color4, bold = true },
    CmpItemKindSnippet = C.color2,
    CmpItemKindConstant = { fg = C.color3, bold = true },
    CmpItemKindConstructor = C.color4,
    CmpitemKindEnum = C.color3,
    CmpItemKindEvent = C.color1,
    CmpitemKindInterface = C.color3,
    CmpItemKindKeyboard = C.color5,
    CmpItemKindClass = C.color3,
    CmpItemKindModule = C.color1,
    CmpItemKindOperator = C.comment,
    CmpitemKindTypeParameter = C.color3,
    CmpItemKindUnit = C.color2,
    CmpItemKindVariable = C.color6,
    CmpItemKindInterface = { link = "CmpItemKindVariable" },
    CmpItemKindText = { link = "CmpItemKindVariable" },
    CmpItemKindFunction = C.color4,
    CmpItemKindMethod = { link = "CmpItemKindFunction" },
    CmpItemKindProperty = { link = "CmpItemKindKeyword" },
    CmpItemKindFolder = { fg = "#f1d068" },
    CmpItemKindFile = C.color1,
    CmpItemKindStruct = C.color3,
    -- Cmp doc
    CmpDocNormalFloat = { bg = C.selection },
    CmpDocFloatBorder = { bg = C.selection, fg = C.border, blend = 10 },
}
