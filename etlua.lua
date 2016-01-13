--- lexer for etlua.
-- Uses embeddings of lua and html.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- @copyright 2016
-- @license MIT (see LICENSE)
-- @module etlua

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'etlua'}

local html = l.load("html")
local lual = l.load("lua")

-- Embed lua to html.
local escapes = S('=-')
local lual_start_rule = token('etlua_tag', '<%' + '<%' * escapes^-1)
local lual_end_rule   = token('etlua_tag', '%>' + P('-')^-1 * '%>')
l.embed_lexer(html, lual, lual_start_rule, lual_end_rule)

M._tokenstyles = {
  etlua_tag = l.STYLE_EMBEDDED
}

local _foldsymbols = html._foldsymbols
_foldsymbols._patterns[#_foldsymbols._patterns + 1] = '<%%'
_foldsymbols._patterns[#_foldsymbols._patterns + 1] = '%%>'
_foldsymbols.rhtml_tag = {['<%'] = 1, ['%>'] = -1}
M._foldsymbols = _foldsymbols

return M
