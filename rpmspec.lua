--- RPM Spec LPeg lexer.
-- @author [Alejandro Baez](https://keybase.io/baez)
-- copyright 2016
-- @license MIT (see LICENSE)
-- @module rpmspec

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'rpmspec'}

-- Whitespace
local ws = token(l.WHITESPACE,  l.space^1)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, '%' * word_match{
  -- Build-time Scripts
  'build', 'prep', 'install', 'clean',
  -- Install/Erase-time Scripts
  'pre', 'post', 'preun', 'postun',
  -- Verification-Time Script
  'verifyscript',

  -- Package Builders macros
  'setup', 'patch',

  -- File
  'files',
  -- File-related Directives
  'doc', 'config', 'attr', 'verify',
  -- Directory-related Directives
  'docdir', 'dir',

  -- Package directive
  'package',

  -- Conditionals
  'ifarch', 'ifnarch', 'ifos', 'ifnos', 'else', 'endif',

  -- really a tag
  'description'
})

-- Tags.
local tags_default = word_match({
  -- Package Naming Tags
  'name', 'version', 'release',
  -- Descriptive Tags
  'description', 'summary', 'copyright',  'distribution',
  'icon', 'vendor', 'url', 'group',  'packager',
  -- Dependency Tags
  'provides', 'requires', 'conflicts', 'serial', 'autoreqprov',
  -- Architecture Tags
  'excludearch', 'exclusivearch',  'excludeos', 'exclusiveos',
  -- Directory-related Tags
  'prefix', 'buildroot',
  -- Source and Patch Tags
  'source', 'nosource', 'patch', 'nopatch'
}, '', true)

local tags_any = l.word * l.space^0

local tags = token("tags",  tags_default * ':')


-- identifiers
--local identifier = token(l.IDENTIFIER, l.word)

-- Variable.
local vars = S'%'^1 * ('{' * l.word * '}')
local variable = token("variable", vars)

-- Macros.
local macros = '%' * l.word

local custom = token("custom", (tags_any * ':') + macros )

-- Operators.
local base_ops = S('%:\\[],-=:{}')
local exp_ops = S('@$?*/')
local operator = token(l.OPERATOR, base_ops)

M._rules = {
  {'whitespace', ws},
  {'keyword', keyword},
  {'variable', variable},
  --{'string', string},
  {'tags', tags},
  {'custom', custom},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
  --{'identifier', identifier},
}

M._tokenstyles = {
  variable    = l.STYLE_VARIABLE,
  tags = l.STYLE_TYPE,
  custom = l.STYLE_FUNCTION,
}

M._FOLDBYINDENTATION = true

return M

