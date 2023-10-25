local C = require "ui.theme.colors"

return {
    SagaLightBulb = C.color4,
    SagaCount = C.color6,
    SagaBeacon = { bg = C.selection },
    SagaFilename = { fg = C.foreground },
    SagaFolderName = { fg = C.comment },
    SagaFolder = { fg = C.color4 },
    SagaWinbarSep = { fg = C.comment },
    SagaInCurrent = { fg = C.color4 },
    SagaModule = { fg = C.color1 },
    -- This is for the diagnostics thing.
    DiagnosticShowBorder = { link = "FloatBorder" },
    SagaBorder = { link = "FloatBorder" },
}
