#!/bin/ksh

. ~/.config/ksh/shortdir.ksh
. ~/.config/ksh/git.ksh

function prompt {
  _prompt=""

  IFS='/'
  set -- $PWD
  if [[ "$1" = "" ]]; then shift; fi

  replaceHome="$(replaceHome "$@")"
  set -- $replaceHome

  if [[ $# -gt 2 ]]; then
    shortenDirs="$(shortenDirs "$@")"
    set -- $shortenDirs
  fi

  dir=$(printf "%s${IFS}" "$@")
  [ -z $DISABLE_PROMPT_COLOR ] &&
    _prompt="${_prompt}$(colored BRIGHT_YELLOW " ${dir} ")" ||
    _prompt="${_prompt}${dir}"

  branch=$(git_branch)
  if [[ "$?" -eq 0 ]]; then
    _prompt="${_prompt} "  # insert space
    [ -z $DISABLE_PROMPT_COLOR ] &&
      _prompt="${_prompt}$(colored BRIGHT_BLUE " ${branch} ")" ||
      _prompt="${_prompt}[${branch}]"
  fi

  printf "$_prompt" "$_prev_stat"
}

[ $DEBUG ] && prompt
