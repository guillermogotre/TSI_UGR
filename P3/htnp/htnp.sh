#!/bin/bash
command -v wine >/dev/null 2>&1 || { echo >&2 "wine required but not installed.  Aborting."; exit 1; }
command -v dos2unix >/dev/null 2>&1 || { echo >&2 "dos2unix required but not installed.  Aborting."; exit 1; }
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wine $DIR/htnp.exe $@ 2>&1  | dos2unix