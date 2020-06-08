#!/bin/bash
apppath=`which $0`
appdir=$(dirname $(realpath ${apppath}))
LUA_PATH="${LUA_PATH};${appdir}/?.lua;./?.lua"
export LUA_PATH
lua ${appdir}/manga.lua "$@"
