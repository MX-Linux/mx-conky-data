#!/bin/bash

playback_status=`audtool --playback-status`

status=`audtool --playback-status`
song=`audtool --current-song-tuple-data title`

if [ "${playback_status}" == "playing" ];
then
    echo ${song}
fi
    
