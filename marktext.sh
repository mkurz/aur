#!/usr/bin/env sh

export MARKTEXT_RESOURCES_PATH="${MARKTEXT_RESOURCES_PATH:-/usr/lib/marktext}"
export MARKTEXT_RIPGREP_PATH="${MARKTEXT_RIPGREP_PATH:-/usr/bin/rg}"
exec @ELECTRON@ /usr/lib/marktext/app.asar "$@"
