#!/bin/ksh

function git_root {
	root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [ $? -eq 0 ]; then
		printf "%s" "${root##/*/}"
		return 0
	else
		printf "%s" ""
		return 1
	fi
}

function git_branch {
	branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ $? -eq 0 ]; then
		printf "%s" "$branch"
		return 0
	else
		printf "%s" ""
		return 1
	fi
}
