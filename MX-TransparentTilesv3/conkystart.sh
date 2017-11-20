#!/bin/bash
sleep 30 &
conky -c ~/.conky/time &
conky -c ~/.conky/systemstat &
conky -c ~/.conky/weather_now &
sleep 5 &
conky -c ~/.conky/weather_forecast &
conky -c ~/.conky/news &
conky -c ~/.conky/webupd8 &
exit 0
