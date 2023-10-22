local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	b.formatting.prettier.with({ filetypes = { "html", "css" } }), -- so prettier works only on these filetypes

	-- .env
	b.diagnostics.dotenv_linter,

	-- fish
	b.diagnostics.fish,

	-- protocol buffers
	b.diagnostics.protolint,

	-- bash
	b.hover.printenv,

	-- Lua
	b.formatting.stylua,

	-- cpp
	b.formatting.clang_format,
	b.diagnostics.cppcheck,

	-- python
	-- b.formatting.autoflake,
	-- b.formatting.autopep8,
	b.formatting.pyink,

	-- rust
	b.formatting.rustfmt.with({
		extra_args = { "--edition=2021" },
	}),

	-- go
	b.formatting.gofumpt,
	b.formatting.goimports,
	b.code_actions.gomodifytags,
	b.code_actions.impl,

	-- general
	-- b.diagnostics.codespell,
	-- b.diagnostics.cspell,
	-- b.code_actions.cspell,
	b.diagnostics.actionlint,
	b.diagnostics.commitlint,

	-- disable formatting for specific flietypes
	null_ls.builtins.formatting.prettierd.with({
		disabled_filetypes = { "markdown", "md"},
	}),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	debug = true,
	sources = sources,

	-- Format on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
