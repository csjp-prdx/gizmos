#!/bin/ksh

source ~/.config/ksh/shortdir.ksh
source ~/.config/ksh/git.ksh

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
  _prompt="${_prompt} $(colored BRIGHT_YELLOW " ${dir} ")"

  branch=$(git_branch)
  if [[ "$?" -eq 0 ]]; then
    _prompt="${_prompt} $(colored BRIGHT_BLUE " ${branch} ")"
  fi

  printf "$_prompt" "$_prev_stat"
}

[ $DEBUG ] && prompt
