#!/bin/bash

playback_status=`audtool --playback-status`

status=`audtool --playback-status`
album=`audtool --current-song-tuple-data album`

if [ "${playback_status}" == "playing" ];
then
    echo ${album}
fi
    
