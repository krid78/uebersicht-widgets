# Übersicht Widgets

A number of widgets for [Übersicht](http://tracesof.net/uebersicht/).

As I'm a fan of [solarized](), I changed the colors of all widgets to solarized-dark.

## NetworkInfo

This module is based on "NetworkInfo" by Chris Johnson. I reworked the shell script to reduce the number of process-calls.
### Credits
    "name": "NetworkInfo",
    "description" : "Displays current Ethernet and Wi-Fi status (connected / not connected / IP Address / Mac Address.",
    "author" : "Chris Johnson",
    "email" : "Chris.1@nosnhoj.com"

## TopCpuProcesses

This one is created by myself. The Idea is taken from [Brett Terpstra]()

## TopRamProcesses

## calendar

A nice looking calendar widget. As I did not like the way it created the calendar in the background, I wrote a little python script for that.

### Credits
    "name": "calendar",
    "description": "Display a simple calendar for the current month.",
    "author": "Adam Vaughan",
    "email": "adamjvaughan@gmail.com"

## memory-bar

Shows the current memory usage. I only adapted the colors to solarized-dark.

### Credits
    "name": "Memory bar",
    "description": "A simple system memory usage meter.",
    "author": "Coby Chapple",
    "email": "coby@github.com"

## tmstatus

This is a fancy way of showing the current tm status. I only adapted the colors to solarized-dark.

### Credits
    "name": "tmstatus",
    "description" : "Displays current Time Machine process status discreetly.",
    "author" : "Adrian Rudman",
    "email" : "a.rudman@binarylight.com.au"

# TODO

	- rework update function @NetworkInfo
		- currently it's redrawn at each update
		- it would be better to only redraw on changes
