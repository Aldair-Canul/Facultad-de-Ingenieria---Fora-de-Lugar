#!/bin/sh
printf '\033c\033]0;%s\a' Fora Meserear260701
base_path="$(dirname "$(realpath "$0")")"
"$base_path/ForaDeLugar.x86_64" "$@"
