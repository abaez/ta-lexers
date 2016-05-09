--- lexer for [Solidity](https://solidity.readthedocs.io/en/latest/)
-- Used haskell as reference.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- @copyright 2016
-- @license MIT (see LICENSE)
-- @module solidity

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'solidity'}

-- Whitespace.
local ws = token(l.WHITESPACE,  l.space^1)

-- Comments.
local line_comment = '//' * l.nonnewline_esc^0
local block_comment = '/*' * (l.any - '*/')^0 * P('*/')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- Strings.
local sq_str = l.delimited_range("'", false, true)
local dq_str = l.delimited_range('"', false, true)
local string = token(l.STRING, sq_str + dq_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- keywords reversed for future use
local future_key = word_match{
  'as',           'case',         'catch',      'final',        'inline',
  'let',          'match',        'of',         'relocatable',  'switch',
  'try',          'type',         'typeof',     'using',
}

-- default keys
local default_key = word_match{
  'anonymous',    'assembly',     'break',      'constant',     'continue',
  'contract',     'default',      'delete',     'do',           'else',
  'enum',         'event',        'external',   'for',          'function',
  'if',           'indexed',      'internal',   'import',       'import',
  'is',           'library',      'mapping',    'memory',       'modifier',
  'new',          'public',       'private',    'return',       'returns',
  'storage',      'struct',       'throw',      'var',          'while',
}

local keyword = token(l.KEYWORD, default_key + future_key)

-- literal types
local literals = word_match{
  'address',     'bool',          'byte',       'false',
  'null',       'true',
  'false',       'string',
  'memory',      'storage',
}

-- dynamic types
local dynamic = word_match{
  'bytes',        'int',          'uint'
}

local type = token(l.TYPE, literals + dynamic + (dynamic * l.dec_num))

-- Operators.
local operator = token(l.OPERATOR, S'()[]{}:;.?=<>|^&-+*/%,!~')

-- Identifiers.
local identifier = token(l.IDENTIFIER, l.word)

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'type', type},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
  {'identifier', identifier}
}

M._foldsymbols = {
  _patterns = {'%l+', '[{}]', '/%*', '%*/', '//'},
  [l.COMMENT] = {['/*'] = 1, ['*/'] = -1, ['//'] = l.fold_line_comments('//')},
  [l.OPERATOR] = {['('] = 1, ['{'] = 1, [')'] = -1, ['}'] = -1}
}


return M
