# Comedy Festival

Browse the line up for the comedy festival.

![https://github.com/simonbs/comedyfestival/raw/master/screenshot.png]

## Getting started

First you need to deploy [the small API](http://github.com/simonbs/comedy-festival-api). The app will attempt to fetch the up to date data from the API.

When you have deployed the API, you need to configure the app so it points to your API.

1. Copy ComedyFestival/Config.temp.plist to ComedyFestival/Config.plist.
2. Update the value for the `comedyFestivalAPIBaseURL` in the property list you just created. This should be the base URL for the API you deployed.

That's it.

## Disclaimer

This project is in not associated with Zulu Comedy Festival. This year there is no official app for the comedy festival but I like to browse the line up for the festival on my phone. Therefore I made this teeny tiny app.
