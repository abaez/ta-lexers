--- lexer for pico8.
-- Uses embeddings of lua and text for pico8.
-- @author [Alejandro Baez](https://twitter.com/a_baez)
-- @copyright 2015
-- @license MIT (see LICENSE)
-- @module pico8

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'pico8'}

local text = l.load("html")
local lual = l.load("lua")

-- Embed lua to text.
local lual_start_rule = token('pico8_tag', '__lua__')
local lual_end_rule   = token('pico8_tag', '__gfx__' )
l.embed_lexer(text, lual, lual_start_rule, lual_end_rule)

M._tokenstyles = {
  pico8_tag = l.STYLE_EMBEDDED
}

return M
