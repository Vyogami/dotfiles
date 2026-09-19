--type conform.options
local util = require "conform.util"

local options = {
  lsp_fallback = true,

  formatters_by_ft = {
    lua = { "stylua" },

    javascript = { "prettier", "eslint" },
    javascriptreact = { "prettier", "eslint" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "black" },
    go = { "gofumpt" },

    sh = { "shfmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },

  formatters = {
    eslint = {
      command = util.from_node_modules "eslint",
      args = { "$FILENAME", "--fix" },
      cwd = util.root_file {
        "package.json",
        ".eslintrc.cjs",
      },
    },
  },
}

require("conform").setup(options)
