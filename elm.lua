--- lexer for [Elm](http://elm-lang.org/docs/syntax).
-- Used haskell as reference.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- @copyright 2016
-- @license MIT (see LICENSE)
-- @module elm

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'elm'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local line_comment = '--' * l.nonnewline_esc^0
local block_comment = '{-' * (l.any - '-}')^0 * P('-}')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local string = token(l.STRING, l.delimited_range('"'))

-- Chars.
local char = token(l.STRING, "'" * l.alpha * "'")

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'as',         'alias',      'and',      'case',     'else',
  'exposing',   'if',         'in',       'infixr',   'import',
  'let',        'module',     'not',      'of',       'or',
  'port',       'then',       'type',     'var',      'where'
})

-- Types.
local type = token(l.TYPE, l.upper * (l.lower + l.dec_num)^1)

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Operators.
local operator = token(l.OPERATOR, S"-+/*^&`,.:;={}()[]<>?|\\")


M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'type', type},
  {'char', char},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
  {'identifier', identifier}
}

M._FOLDBYINDENTATION = true

return M
