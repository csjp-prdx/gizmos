#!/bin/ksh

source ~/.config/ksh/colored.ksh

function shortenDirs {
  shortenTo=1
  j=$(($#-1))

  for i in "$@"; do
    if [[ $j -gt 0 ]]; then
      first=$(printf "%.1s" "$i")

      if [[ "$first" = "." ]]; then
        printf "%.${((shortenTo+1))}s${IFS}" "$i"
      else
        printf "%.${shortenTo}s${IFS}" "$i"
      fi

    else
      printf "%s" "$i"
    fi

    j=$((j-1))
  done
}

function replaceHome {
  if [[ "${IFS}${1}${IFS}${2}" = "$HOME" ]]; then
    shift && shift
    printf "%s" "~"
    printf "${IFS}%s" "$@"
  else
    printf "${IFS}%s" "$@"
  fi
}
