#!/bin/bash

playback_status=`audtool --playback-status`

if [ "${playback_status}" == "playing" ];
then
    echo "show_bg"
fi
    
