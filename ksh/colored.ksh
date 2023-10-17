#!/bin/bin/env ksh

typeset -A color

color[black]=0
color[red]=1
color[green]=2
color[yellow]=3
color[blue]=4
color[magenta]=5
color[cyan]=6
color[white]=7

color[bright_black]=8
color[bright_red]=9
color[bright_green]=10
color[bright_yellow]=11
color[bright_blue]=12
color[bright_magenta]=13
color[bright_cyan]=14
color[bright_white]=15

function colored {
	opt=$(echo "$1" | tr '[:upper:]' '[:lower:]')
	shift

	if [ "${color[${opt}]}" -ge 0 ] && [ "${color[${opt}]}" -lt 16 ]; then
		msg="\u001b[48;5;${color[${opt}]}m${@}\u001b[0m"
	else
		msg="$@"
	fi

	printf "%s" "$msg"
}

[ $DEBUG_COLORED ] && printf "$(colored bright_yellow yellow bg text $'\n')"
