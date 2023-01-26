#!/usr/bin/env bash

function get_load_average() {
  case $(uname -s) in
    Linux | Darwin)
      loadavg=$(uptime | awk -F'[a-z]:' '{print $2}' | sed 's/,//g')
      echo "$loadavg"
      ;;
    *)
      ;;
  esac

  return 0
}

get_load_average
