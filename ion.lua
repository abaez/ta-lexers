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

-- Numbers
local number = token(l.NUMBER, l.float + l.integer)

