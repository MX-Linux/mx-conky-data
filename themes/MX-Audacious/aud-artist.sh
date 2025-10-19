#!/bin/bash

playback_status=`audtool --playback-status`

status=`audtool --playback-status`
artist=`audtool --current-song-tuple-data artist`

if [ "${playback_status}" == "playing" ];
then
    echo ${artist}
fi
    
