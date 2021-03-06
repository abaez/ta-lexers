--- Dockerfile LPeg lexer.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- copyright 2016
-- @license MIT (see LICENSE)
-- @module dockerfile

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'dockerfile'}

-- Whitespace
local indent = #l.starts_line(S(' \t')) *
               (token(l.WHITESPACE, ' ') + token('indent_error', '\t'))^1
local ws = token(l.WHITESPACE, S(' \t')^1 + l.newline^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Strings.
local sq_str = l.delimited_range("'", false, true)
local dq_str = l.delimited_range('"')
local string = token(l.STRING, sq_str + dq_str)

-- numbers
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  "FROM",     "MAINTAINER",   "RUN",      "CMD",
  "LABEL",    "EXPOSE",       "ENV",      "ADD",
  "COPY",     "ENTRYPOINT",   "VOLUME",   "USER",
  "WORKDIR",  "ARG",          "ONBUILD",  "STOPSIGNAL"
})

-- identifiers
local identifier = token(l.IDENTIFIER, l.word)

-- variable
local vars = S'$'^1 * (S'{'^1 * l.word * S'}'^1 + l.word)
local variable = token("variable", vars)

-- Operators.
local base_ops = S('\\[],=:{}')
local exp_ops = S('@$?*/')
local operator = token(l.OPERATOR, base_ops)

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'variable', variable},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
  {'identifier', identifier},
}

M._tokenstyles = {
  variable    = l.STYLE_VARIABLE,
}

M._FOLDBYINDENTATION = true

return M
