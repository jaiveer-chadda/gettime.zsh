#!/usr/bin/env zsh

zmodload zsh/datetime

function gettime () {

  setopt local_options warn_create_global

  # ——————————————————————————————————————————————————— #

  local mode='t' # 't' or 'd'

  local opt OPTARG OPTIND
  while { getopts 'td' opt; } { #
    case "$opt" {
      ( [td] ) mode="$opt" ;;
      (  *   ) echo "unknown option '-$opt'"; return 1 ;;
    }
  }

  shift 'OPTIND - 1'

  # ——————————————————————————————————————————————————— #

  local -r file="${1:?must provide a filename}"
  local -i 10 timestamp; timestamp="$( stat -f '%m' "$file" )" || return $?

  if [[ $mode == 't' ]] {
    # [[CC]YY]MMDDhhmm[.SS]
    strftime -n '%0Y%0m%0d%0H%0M.%0S' "$timestamp"
  } else {
    # YYYY-MM-DDThh:mm:SS[.frac][tz]
    strftime -n '%0Y-%0m-%0dT%0H:%0M:%0S' "$timestamp"
  }

  if [[ -t 1 ]] echo # if printing to a tty, add a newline after the output
}

if [[ "$ZSH_EVAL_CONTEXT" == 'toplevel' ]] gettime "$@"
