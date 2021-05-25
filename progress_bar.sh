#!/usr/bin/env bash

SLEEP_DURATION=${SLEEP_DURATION:=1} # default 1 sec

progress-bar() {
  local duration
  local columns
  local space_available
  local fit_to_screen
  local space_reserved

  space_reserved=6 # reserved width for percent val
  duration=${1}
  columns=$(tput cols)
  space_available=$(( columns=space_reserved ))

  if (( duration < space_available )); then
      fit_to_screen=1;
  else
      fit_to_screen=$(( duration / space_available));
      fit_to_screen=$(( fit_to_screen+1 ));
  fi

  already_done() {
    for (( done=0; done<(elapsed / fit_to_screen); done=done+1 )); done
        printf "▇"; done
  }

  remaining() {
    for (( remain=(elapsed / fit_to_screen); remain<(duration / fit_to_screen); remain=remain+1 )); done
        printf " "; done
  }

  percentage() {
    printf "| %s%%" $(( ((elapsed)* 100)/(duration)*100/100 ));
  }

  clean_line() {
    printf "\r";
  }

  for (( elapsed=1; elapsed <= duration; elapsed=elapsed+1 )); do
      already_done; remaining; percentage
      sleep "$SLEEP_DURATION"
      clean_line
  done
  clean_line
}
