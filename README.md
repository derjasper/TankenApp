# TankenApp

Real time fuel prices.

## Features

* list and map view, details view
* choose or detect location
* filter and sorting supported
* multiple APIs
* responsive layout (beta)

## Supported APIs

* Tankerkoenig.de (official MTS-K data for Germany - https://creativecommons.tankerkoenig.de/)
* Spritpreisrechner.at (official data for Austria - http://spritpreisrechner.at/)
* geoportalgasolineras.es (official data for Spain - http://geoportalgasolineras.es/), uses self-hosted web service (beta)
* prix-carburants.gouv.fr (official data for France - https://prix-carburants.gouv.fr/), uses self-hosted web service (beta)
* carburanti.mise.gov.it (official data for Italy - https://carburanti.mise.gov.it/OssPrezziSearch/)
* myGasFeed.com (user contributed data in USA - http://www.mygasfeed.com/)

## Translations

Please submit translations at https://translations.launchpad.net/tankenapp.

## Building the app

* **Obtain API keys**: Before you can build the app you need to rename the file `qml/api/apikeys_template.js` to `apikeys.js` and request all needed api keys.
* **Build**: Ubuntu apps are now build using [clickable](http://clickable.bhdouglass.com/), the SDK won't work. Simply run `clickable` in the projects folder to run the app on a phone or `clickable desktop` for testing on the desktop.
