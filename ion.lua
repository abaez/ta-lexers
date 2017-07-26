--- Ion shell LPeg lexer.
-- @author [Alejandro Baez](https://twitter.com/a_baez)
-- copyright 2017
-- @license MIT (see LICENSE)
-- @module ion

local l = require("lexer")
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'ion'}

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- shebang
local shebang = token('shebang', '#!/' * l.nonnewline^0)

-- Comments.
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- Strings.
local sq_str = l.delimited_range("'", false, true)
local dq_str = l.delimited_range('"')
local str = token(l.STRING, sq_str + dq_str)

-- Numbers.
local number = token(l.NUMBER, l.float + l.integer)

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  'alias', 'bg', 'command', 'disown', 'drop', 'echo', 'else', 'end', 'exit', 'export', 'fg', 'fn', 'for', 'if', 'in', 'let', 'unalias', 'suspend', 'test', 'while'
})

-- Variables.
local variable = token(l.VARIABLE,
                       '$' * l.word +
                       '$' * l.delimited_range('{}', true, true))

-- Operators.
local operator = token(l.OPERATOR, S('=!<>+-/*^&|~.,:;?()[]{}'))

M._rules = {
  {'whitespace', ws},
  {'shebang', shebang},
  {'keyword', keyword},
  {'variable', variable},
  {'identifier', identifier},
  {'string', string},
  {'comment', comment},
  {'number', number},
  {'operator', operator},
}

M._tokenstyles = {
  shebang = l.STYLE_LABEL
}

M._foldsymbols = {
  _patterns = {'%l+'},
  [l.KEYWORD] = {
    ['if'] = 1, ['fn'] = 1, ['for'] = 1, ['while'] = 1, ['end'] = -1
  }
}

return M
