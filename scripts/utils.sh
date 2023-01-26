#!/usr/bin/env bash

function set() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

function append() {
  local option="$1"
  local value="$2"
  tmux set-option -gaq "$option" "$value"
}

function get() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [[ -z "$option_value" ]]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}
