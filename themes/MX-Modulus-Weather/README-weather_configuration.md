Configuring the weather conky called "weather_dynamic_icons" 

1) ensure you have the package called "jq" installed on your system.  You can search for this package in MX Packageinstaller [MXPI] "Enabled Repos" and if not installed, use MXPI to do so.

2) get your city ID at https://openweathermap.org/find .  Enter your location into the search box and click on the most relevant search result.  In the next page that opens, the City ID comprising 7 digits will be found in the URL address displayed in the address bar.

3) open the file called "weather-v2.0.sh" in a text editor, enter your city ID, then save the file.

4) (optional step) you can use the openweathermap api key already entered in the weather-v2.0 file.  It was provided by the creator of the script.  However, you may wish to replace that key with your own.  You can get your own api key for free at https://openweathermap.org/ .  This will avoid too many api calls being made from the same key at any point in time.  The script creator has stated:

"Since there are limitations to API calls from openweather, I suggest creating your own api_key and then overwrite the one in weather-v2.0.sh .... to avoid occasional error (appears Null )...."

[quoted from https://www.pling.com/p/1985086 ]



Differences between the weather conky in the Modulus base set (wttrrc) and this conky:

1. they use different weather services for their weather data, so depending on your location, one conky may display more accurate weather data than the other for you.

2. wttrrc displays the weather conditions in text only - the icon is a static graphic.  On the other hand, dynamic_weather_icons has weather icons that change to match the current weather condition, in addition to text. 

Use which works best for you.  Each of these conkies is configured to take up the same position in the whole row of Modulus conkies. 



