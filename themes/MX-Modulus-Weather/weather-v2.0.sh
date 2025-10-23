#!/bin/bash

# v2.0 Closebox73
# This script is to get weather data from openweathermap.com in the form of a json file
# so that conky will still display the weather when offline even though it doesn't update

# Variables
# get your city id at https://openweathermap.org/find ==> click on search result and locate city id [7 digits] in the URL, enter into line below
city_id=

# you can use this or replace with yours
api_key=e46d6b1c945f2e9983f0735f8928ea2f

# choose between metric for Celcius or imperial for fahrenheit
unit=metric

# i'm not sure it will support all languange, 
lang=en

# Main command
url="api.openweathermap.org/data/2.5/weather?id=${city_id}&appid=${api_key}&cnt=5&units=${unit}&lang=${lang}"
curl ${url} -s -o ~/.cache/weather.json

exit
