#!/bin/bash

#
# Returns a list of the harddisks, in a conky-style configuration.
# (C) 2010 Semplice Team. All rights reserved.
# This file is released under the terms of the GNU GPL license, version 3 or later.
#



# For now only for /home
if [ "`mount | grep -w \"/home\" | awk '{ print $1 }'`" ]; then
echo '   ${voffset -12}/home:'
echo '   ${voffset 4}${fs_used /home} of ${fs_size /home} ${alignr}${fs_bar 8,90 /home}'
echo
fi

LANG=C mount | grep "/media" | sed 's/.* on //g' | sed 's/type .*//g' | while read media; do
echo '   ${voffset -8}${color}'"$media":
echo '   ${voffset 4}${fs_used' "$media"'} of ${fs_size' "$media"'} ${alignr}${color #FFF600}${fs_bar 8,90' "$media}"
echo ''
done

