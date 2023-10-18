#!/bin/ksh

function color {
	_opt=-1
	case "$1" in
		"black")          _opt=0  ;;
		"red")            _opt=1  ;;
		"green")          _opt=2  ;;
		"yellow")         _opt=3  ;;
		"blue")           _opt=4  ;;
		"magenta")        _opt=5  ;;
		"cyan")           _opt=6  ;;
		"white")          _opt=7  ;;
		"bright_black")   _opt=8  ;;
		"bright_red")     _opt=9  ;;
		"bright_green")   _opt=10 ;;
		"bright_yellow")  _opt=11 ;;
		"bright_blue")    _opt=12 ;;
		"bright_magenta") _opt=13 ;;
		"bright_cyan")    _opt=14 ;;
		"bright_white")   _opt=15 ;;
	esac
	printf "%s" "$_opt"
}

function colored {
	if [[ "$COLORTERM" != truecolor ]] && [[ "$COLORTERM" != 24bit ]]; then
		printf "%s" "$@"
		exit
	fi

	opt=$(echo "$1" | tr '[:upper:]' '[:lower:]')
	opt=$(color $opt)
	[ $DEBUG_COLORED ] && printf "%s\n" "$opt"

	shift

	if [ "$opt" -ge 0 ] && [ "$opt" -lt 16 ]; then
		msg="\u001b[48;5;${opt}m${@}\u001b[0m"
	else
		msg="$@"
	fi

	printf "%s" "$msg"
}

[ $DEBUG_COLORED ] && printf "$(colored black black text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored red red text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored green green text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored yellow yellow text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored blue blue text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored magenta magenta text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored cyan cyan text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored white white text $'\n')"

[ $DEBUG_COLORED ] && printf "$(colored bright_black bright_black text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_red bright_red text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_green bright_green text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_yellow bright_yellow text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_blue bright_blue text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_magenta bright_magenta text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_cyan bright_cyan text $'\n')"
[ $DEBUG_COLORED ] && printf "$(colored bright_white bright_white text $'\n')"