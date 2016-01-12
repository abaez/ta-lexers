--- lexer for pico8.
-- Uses embeddings of lua and text for pico8.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- @copyright 2016
-- @license MIT (see LICENSE)
-- @module pico8

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'pico8'}

local lual = l.load("lua")

-- Embed lua to pico ;).
local lual_start_rule = token('pico8_tag', '__lua__')
local lual_end_rule   = token('pico8_tag', '__gfx__' )
l.embed_lexer(text, lual, lual_start_rule, lual_end_rule)

-- Whitespace
local ws = token(l.WHITESPACE, l.space^1)

-- Comments
local line_comment = '//' * l.nonnewline_esc^0
local comment = token(l.COMMENT, line_comment)

-- Numbers
local number = token(l.NUMBER, l.integer)

-- Keywords
local keyword = token(l.KEYWORD, word_match{
  'lua', 'gfx', 'gff', 'map', 'sfx', 'music'
} * l.delimited_range("__"))

-- Identifiers
local identifier = token(l.IDENTIFIER, l.word)

-- Operators
local operator = token(l.OPERATOR, S('_'))

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'identifier', identifier},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
}


M._tokenstyles = {
  pico8_tag = l.STYLE_EMBEDDED
}

return M
