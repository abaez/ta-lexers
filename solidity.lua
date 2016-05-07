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

-- keywords reversed for future use
local future_key = word_match{
  'as',           'case',         'catch',      'final',        'inline',
  'let',          'match',        'of',         'relocatable',  'switch',
  'try',          'type',         'typeof',     'using',
}

local default_key = word_match{
  'anonymous',    'assembly',     'break',      'constant',     'continue',
  'contract',     'default',      'do',         'else',         'enum',
  'event',        'external',     'for',        'function',     'if',
  'indexed',      'internal',     'import',     'import',       'is',
  'library',      'mapping',      'memory',     'modifier',     'new',
  'public',       'private',      'return',     'returns',      'storage',
  'struct',       'throw',        'var',        'while'
}

local keyword = token(l.KEYWORD, default_key + future_key)



local operator = token(l.OPERATOR, S'()[]{}:;.?=<>|^&-+*/%,!~')

return M
