function ccat {
  while (( $# )); do
    if [[ $1 == *.md ]] || [[ $1 == *.markdown ]]; then
      glow $1
    else
      bat -pp --theme=base16 $1
    fi
    shift
  done
}
