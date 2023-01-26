#!/usr/bin/env bash

function get_lan_ip() {
  case $(uname -s) in
    Darwin)
      local all_nics="$(ifconfig 2> /dev/null | awk -F':' '/^[a-z]/ && !/^lo/ { print $1 }' | tr '\n' ' ')"
      IFS=' ' read -ra all_nics_array <<< "$all_nics"
      for nic in "${all_nics_array[@]}"; do
        ipv4s_on_nic="$(ifconfig ${nic} 2> /dev/null | awk '$1 == "inet" { print $2 }')"
        for lan_ip in "${ipv4s_on_nic[@]}"; do
          [[ -n "${lan_ip}" ]] && break
        done
        [[ -n "${lan_ip}" ]] && break
      done
      ;;
    Linux)
      local all_nics="$(ip addr show | cut -d ' ' -f2 | tr -d :)"
      local all_nics=(${all_nics[@]/lo/})

      for nic in "${all_nics[@]}"; do
        local lan_ip="$(ip addr show ${nic} | grep '\<inet\>' | tr -s ' ' | cut -d ' ' -f3)"
        lan_ip="${lan_ip%/*}"
        lan_ip="$(echo "$lan_ip" | tail -1)"

        [[ -n "$lan_ip" ]] && break
      done
      ;;
  esac

  echo "${lan_ip-N/a}"

  return 0
}

get_lan_ip
