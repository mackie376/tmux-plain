#!/usr/bin/env bash

function get_wan_ip() {
  local tmp_file="${HOME}/.config/tmux/wan_ip.txt"
  local wan_ip
  local last_update

  if [[ -f "$tmp_file" ]]; then
    case $(uname -s) in
      Darwin)
        last_update=$(stat -f "%m" $tmp_file)
        ;;
      Linux)
        last_update=$(stat -c "%Y" $tmp_file)
        ;;
    esac

    local time_now=$(date +%s)
    local udate_period=900
    local up_to_date=$(echo "(${time_now}-${last_update}) < ${update_period}" | bc)

    if [[ "$up_to_date" -eq 1 ]]; then
      wan_ip="$(cat $tmp_file)"
    fi
  fi

  if [[ -z "$wan_ip" ]]; then
    wan_ip=$(curl --max-time 2 -s http://whatismyip.akamai.com/)

    if [[ "$?" -eq "0" ]]; then
      echo "$wan_ip" > $tmp_file
    elif [[ -f "$tmp_file" ]]; then
      wan_ip=$(cat "$tmp_file")
    fi
  fi

  if [[ -n "$wan_ip" ]]; then
    echo "$wan_ip"
  fi

  return 0
}

get_wan_ip
