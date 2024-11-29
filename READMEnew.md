# Asteroid Radar
### Introduction

"Asteroid Radar" is an app that allows you to view asteroids discovered by NASA that pass near Earth, as well as NASA news that frequently reports on asteroids.

You can view the data of all the detected asteroids in the next 7 days (size, velocity, distance to Earth and potentially hazardous or not). 
The information of these asteroids comes from a free, open source API provided by NASA JPL. 
You need to generate an API key by going to https://api.nasa.gov/

### Screens

The app has four screens:
1) Main screen with a list of all the detected asteroids and the NASA image of the day
2) Details screen that displays the data of the selected asteroid 
3) Approach screen that displays all approach data of this asteroid in the past and in the future provided by NASA
4) News screen with NASA news

### Features

- The asteroid data and the news data are saved in Core Data.
- In case there is no internet connection the saved asteroid data and the saved news data are displayed. 
- The NASA image of the day on the main screen is saved in UserDefaults.
- In case there is no internet connection the saved NASA image of the day is displayed. 
- Asteroid data, approach data and NASA image of the day use JSON files from the NASA API.
- The Swift structures matching the JSON Schema are generated with Quicktype.io.
- XMLParsing the news data XML from NASA news.rss using XMLParser and XMLParserDelegate.

### Screenshots
| ![Main Screen](https://raw.githubusercontent.com/MarioArndt42/ubiquitous-journey/main/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202023-09-24%20at%2013.38.55.png) | ![Details Screen](https://raw.githubusercontent.com/MarioArndt42/ubiquitous-journey/main/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202023-09-24%20at%2013.42.25.png) | 
| ------ | ------ | 
| ![Approach Screen](https://raw.githubusercontent.com/MarioArndt42/ubiquitous-journey/main/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202023-09-24%20at%2013.42.45.png) | ![News Screen](https://raw.githubusercontent.com/MarioArndt42/ubiquitous-journey/main/Simulator%20Screen%20Shot%20-%20iPhone%208%20Plus%20-%202023-09-24%20at%2013.43.09.png) |

  

