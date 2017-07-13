--- A terraform lexer for scintillua based editors.
-- @author [Alejandro Baez](https://twitter.com/a_baez)
-- @copyright 2017
-- @license MIT (see LICENSE)
-- @module terraform

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = "terraform"}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local line_comment = '#' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local string = token(l.STRING, l.delimited_range('"'))

-- Numbers.
local number = token(l.NUMBER, l.dec_num + l.hex_num)


-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'true', 'false', 'resource', 'connection', 'variable', 'data', 'output'
  , 'provider', 'module'
})

-- Library functions.
local library = token('library', word_match{
  'basename', 'base64decode', 'base64encode', 'base64sha512', 'bcrypt'
  , 'ceil', 'chomp', 'cidrhost', 'cidrnetmask', 'cidrsubnet', 'coalesce'
  , 'coalescelist', 'compact', 'concat', 'dirname', ' distinct', 'element'
  , 'file', 'floor', 'format', 'formatlist', 'index', 'join', 'jsonencode'
  , 'keys', 'length', 'list', 'log', 'lookup', 'lower', 'map', 'matchkey'
  , 'max', 'merge', 'min', 'md5', 'pathexpand', 'pow', 'replace', 'sha1'
  , 'sha256', 'sha512', 'signum', 'slice', 'sort', 'split', 'substr'
  , 'timestamp', 'title', 'upper', 'uuid', 'values', 'zipmap'
})

local vars = S'$'^1 * (S'{'^1 * l.word * S'}'^1 + l.word)
local variable = token("variable", vars)

-- Operators.
local operator = token(l.OPERATOR, S"#/*=${}(),.?[]:<>!|")

M._rules = {
  {'whitespace', ws}
  , {'keyword', keyword}
  , {'library', library}
  , {'string', string}
  , {'comment', comment}
  , {'variable', variable}
  , {'number', number}
  , {'operator', operator}
  , {'identifier', identifier}
}

M._tokenstyles = {
  library = l.STYLE_FUNCTION,
  variable = l.STYLE_VARIABLE
}

M._foldsymbols = {
  _patterns = {'%l+', '[{}]', '/%*', '%*/', '//'},
  [l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')},
  [l.OPERATOR] = {['{'] = 1, ['}'] = -1}
}

return M
