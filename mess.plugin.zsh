function mess {
  local messpath="${HOME}/mess"      # $HOME/mess
  local now=$(date '+%Y/%V')         # yyyy/ISO_week_number
  local current="${messpath}/${now}" # $HOME/mess/yyyy/ISO_week_number
  local link="${messpath}/current"   # $HOME/mess/current

  # If "$current" does not exist, create it.
  [ ! -d "$current" ] &&
    mkdir -p "$current" &&
    echo "Created ${now}"

  # If "$link" exists and is not a symlink, something is wrong.
  if [ -e "$link" ] &&
    [ ! -L "$link" ]; then
    echo >&2 "${link} is not a symlink; something is wrong."
  else
    # If "$link" and "$current" are not equivalent directories, then re-symlink
    # "$link" to "$current".
    [ ! "$link" -ef "$current" ] &&
      rm -f "$link" &&
      ln -s "$current" "$link"

    local target="${link}/${@}"

    [ -d "$target" ] &&
      cd "$target" ||
      cd "$current"
  fi
}
