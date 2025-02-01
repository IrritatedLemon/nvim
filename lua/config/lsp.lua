local _augroups = {}

local function get_augroup(client)
    if not _augroups[client.id] then
        local group_name = "lsp-format-" .. client.name
        local id = vim.api.nvim_create_augroup(group_name, { clear = true })
        _augroups[client.id] = id
    end

    return _augroups[client.id]
end

local _border = "rounded"

vim.diagnostic.config({
    float = { border = _border },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = _border,
})

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = _border,
    })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),
    callback = function(args)
        local client_id = args.data.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local bufnr = args.buf

        if not client.server_capabilities.documentFormattingProvider then
            return
        end

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    async = false,
                    filter = function(c)
                        return c.id == client.id
                    end,
                })
            end,
        })

        local opts = { buffer = args.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<Leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<Leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<Leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<Leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
})
