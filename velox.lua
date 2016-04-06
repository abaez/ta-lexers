-- lexer for [velox.conf](https://github.com/michaelforney/velox).
-- @author [Alejandro Baez](https://keybase.io/baez)
-- @copyright 2016
-- @license MIT (see LICENSE)
-- @module velox

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'velox'}

-- Whitespace
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Numbers
local number = token(l.NUMBER, l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, l.word_match{
  "action", "button", "key", "rule", "set"
})

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operator
local operator = token(l.OPERATOR, S".,:")

-- Keys
local constant = token(l.CONSTANT, l.word_match({
  "alt", "ctrl", "mod", "return", "shift", "space", "tab",
  "left", "right"

}, nil, true))

local char = token("char", R("az")^-1 * l.space )

-- spawn
local spawn = token("spawn", P"spawn" * l.space^1 * l.nonnewline^0)

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'constant', constant},
  {'char', char},
  {'spawn', spawn},
  {'operator', operator},
  {'comment', comment},
  {'number', number},
  {'identifier', identifier},
}

M._tokenstyles ={
  spawn = l.STYLE_STRING,
  char  = l.STYLE_CONSTANT
}

return M
