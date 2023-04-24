#!/usr/bin/env zsh

while getopts "c:e:s:h" opt; do case "${opt}" in
    c)
      rust_command=${OPTARG}
      shift 2
      ;;
    e)
      local editor=${OPTARG} # should return stuff like nvim, vim, code
      shift 2
      ;;
    s) 
      local size=${OPTARG}
      shift 2
      ;;
    h) 
      echo "this should return a usage out"
      return
      ;;
    :) 
      echo "this should return a usage out"
      echo "TODO: this needs to abort fzf" 
      ;;
    ?) 
      echo "must supply an argument" 
      echo "TODO: this needs to abort fzf" 
      ;;
  esac
done

./target/debug/pseudo-projectile --command $rust_command
