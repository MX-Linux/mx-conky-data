#!/bin/bash

#
# Returns a list of the harddisks, in a conky-style configuration.
# (C) 2010 Semplice Team. All rights reserved.
# This file is released under the terms of the GNU GPL license, version 3 or later.
#

LANG=C lsblk | grep 'part /' | awk -F' ' '{print $7}' | while read media; do
echo '   ${voffset -5}'"$media":
echo '   ${voffset 4}${fs_used' "$media"'} of ${fs_size' "$media"'} ${alignr}${fs_bar 8,60' "$media}"
echo ''
done
