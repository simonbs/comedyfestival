# Comedy Festival

Browse the line up for the comedy festival.

## Getting started

First you need to deploy [the small API](http://github.com/simonbs/comedy-festival-api). The app will attempt to fetch the up to date data from the API.

When you have deployed the API, you need to configure the app so it points to your API. 

1. Copy ComedyFestival/Config.temp.plist to ComedyFestival/Config.plist.
2. Update the value for the `comedyFestivalAPIBaseURL` in the property list you just created. This should be the base URL for the API you deployed.

That's it.

Be aware that the app is written in Swift 4, so you will need to use Xcode 9.

## Disclaimer

This project is in not associated with Zulu Comedy Festival. This year there is no official app for the comedy festival but I like to browse the line up for the festival on my phone. Therefore I made this teeny tiny app.
