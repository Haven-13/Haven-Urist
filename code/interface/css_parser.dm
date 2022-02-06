//!
// Copyright (c) 2022 Martin Lyrå
// SPDX-License-Identifier: MIT
//

// This is a simple, shitty, simpleton of a parser, its true intent is to parse a .css
// file's contents for all --* custom properties and replacing var(--*) uses with the value
// of the corresponding --* variable.

// Why, you might ask? Go ahead, try to load a .css with custom properties and try use them.
// This is a bandaid solution for so long as BYOND still use the fucking shitty IE for its HTML.

/// A holder object for all variables parsed by all css_parsers.
// This is not an intentional design choice, rather, it is enforced by the design of Byond.
// Since it is needed in a regex.Replace() callback proc, which always will use the regex object
// itself instead of the actual owner object.
// As long DM has no anonymous functions or function creating functions (a proc that returns a proc)
// this will be necessary and shall haunt Lummox for long as DM remains this dense.
var/global/list/css_parser_custom_properties = list()

/css_parser
	var/regex/block_stop
	var/regex/root
	var/regex/variable
	var/regex/variable_use

/css_parser/New()
	block_stop = regex("}")
	root = regex(":root")
	variable = regex("--.+:")
	variable_use = regex("var\\((.+)\\)", "g")

/// Parse a CSS string for all `--*` custom properties and replacing `var(--*)` uses with the
/// value of the corresponding `--*` variable. Returns the same CSS string with all the properties
/// replaced with their values.
/css_parser/proc/substitute_custom_properties(in_css, replace=TRUE)
	var/line
	var/list/lines = splittext_char(in_css, "\n")
	. = ""
	for (var/i in 1 to length(lines))
		line = lines[i]
		if(root.Find(line))
			global.css_parser_custom_properties |= parse_root(lines, i + 1)

		. += replace ? \
			variable_use.Replace(line, /css_parser/proc/replace_variable) : \
			variable_use.Replace(line, /css_parser/proc/insert_variable_fallback)

/css_parser/proc/replace_variable(match, varname)
	. = global.css_parser_custom_properties[trim(varname)]

/css_parser/proc/insert_variable_fallback(match, varname)
	. = jointext(list(
			match,
			global.css_parser_custom_properties[trim(varname)]
		),
		", "
	)

/css_parser/proc/parse_root(lines, start)
	. = list()
	var/line
	for(var/i in start to length(lines))
		line = lines[i]
		if(block_stop.Find(line))
			break
		if(variable.Find(line))
			var/list/parts = splittext_char(line, ":")
			.[trim(parts[1])] = replacetext_char(
				trim(parts[2]), ";", ""
			)
