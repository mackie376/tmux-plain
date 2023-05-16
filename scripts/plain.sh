#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${current_dir}/utils.sh"

function plain() {

  ##
  ## basic variables
  ##

  ## get configuration option variables
  local show_icon=$(get '@plain_show_icon' true)
  local show_military=$(get '@plain_show_military' true)
  local left_modules=($(get '@plain_left_modules' 'session loadavg'))
  local right_modules=($(get '@plain_right_modules' 'lan_ip wan_ip hostname'))

  ## Plain theme color palette
  local background='#1a1b26'
  local foreground='#c0caf5'
  local gray='#545c7e'
  local red='#f7768e'
  local green='#9ece6a'
  local yellow='#e0af68'
  local blue='#7aa2f7'
  local magenta='#bb9af7'
  local cyan='#7ccfff'
  local white='#c0caf5'

  ## icons
  local graph_icon=''
  local lan_icon='󰌗'
  local wan_icon='󰖈 '
  local server_icon=""
  local layer_icon=''
  local layer_active_icon=''
  local grid_icon='󰝘'

  ##
  ## functions
  ##

  function get_module_value() {
    local name="$1"
    local result=''

    case "$name" in
      session)
        result="#[bold]#{?client_prefix,#[fg=green],#[fg=blue]} #S "
        ;;
      hostname)
        if $show_icon; then
          result="$server_icon"
        fi
        result=" $result #H "
        ;;
      loadavg)
        if $show_icon; then
          result="$graph_icon"
        fi
        result=" $result#(${current_dir}/get_load_average.sh) "
        ;;
      lan_ip)
        if $show_icon; then
          result="$lan_icon"
        fi
        result=" $result #(${current_dir}/get_lan_ip.sh) "
        ;;
      wan_ip)
        if $show_icon; then
          result="$wan_icon"
        fi
        result=" $result#(${current_dir}/get_wan_ip.sh) "
        ;;
      *)
        ;;
    esac

    echo "$result#[default]"
  }

  ##
  ## status line
  ##

  set status              on
  set status-interval     1
  set status-justify      centre
  set status-position     bottom
  set status-left-length  1000
  set status-right-length 1000
  set status-style        'bg=default,fg=white'
  set status-left         ''
  set status-right        ''

  for module in "${left_modules[@]}"; do
    append status-left "$(get_module_value $module)"
  done
  for module in "${right_modules[@]}"; do
    append status-right "$(get_module_value $module)"
  done

  ##
  ## window
  ##

  set window-status-separator '  '

  set window-status-format "#[bg=default,fg=$gray]"
  if $show_icon; then
    append window-status-format "$layer_icon "
  fi
  append window-status-format "#I:#W#[default]"

  set window-status-current-format "#[bg=default,fg=$foreground]"
  if $show_icon; then
    append window-status-current-format "$layer_active_icon "
  fi
  append window-status-current-format "#I:#W#[default]"

  ##
  ## pane
  ##

  set pane-border-status       bottom
  set pane-border-style        "bg=default,fg=${gray}"
  set pane-active-border-style "bg=default,fg=${blue}"

  set pane-border-format ''
  if $show_icon; then
    append pane-border-format " ${grid_icon}"
  fi
  append pane-border-format ' #P '

  ##
  ## message
  ##

  set message-style  "bg=default,fg=$yellow"

  ##
  ## mode
  ##

  set mode-style "bg=$yellow,fg=$background"

  ##
  ## clock
  ##

  set clock-mode-colour yellow

  if $show_military; then
    set clock-mode-style 24
  else
    set clock-mode-style 12
  fi

}

plain
