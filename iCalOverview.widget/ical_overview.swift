//
//  main.swift
//  CalendarTool
//
//  Created by Benjamin Kunke on 04/11/14.
//  Copyright (c) 2014 Benjamin Kunke. All rights reserved.
//

import Foundation
import EventKit



///////////////////////////////////////////////////////////////////////
class CalendarTool
{


    var debuggingMode = false;

    var includeArray: [String] = []
    var excludeArray: [String] = []
    var tage = 3

    var calendars: [EKCalendar] = []

    var store = EKEventStore()

    //Gregorianischer Kalender
    let nsCalendar = NSCalendar.currentCalendar()

    //Format für Datumsangaben
    var dateFormatterDatum : NSDateFormatter = NSDateFormatter()

    //Format für Uhrzeiten
    var dateFormatterUhrzeit : NSDateFormatter = NSDateFormatter()


    /*

    JSON - Syntax:

    finales JSON-Objekt:        {EventsForNextDays: [dateObject1, dateObject2,...]}
    dateObject:                 {datum: [calendarObject1, calendarObject2,...]}
    calendarObject:             {Kalendertitel : [eventObject1, eventObject2,...]}
    eventObject:                {start: Uhrzeit, ende: Uhrzeit, titel: Eventtitel}

    */

    init()
    {
        dateFormatterDatum.dateFormat = "dd.MM.yyyy"
        dateFormatterUhrzeit.dateFormat = "HH:mm"



        initializeParameters()
        loadCalendars()

    }

    func getJSON()->String
    {
        return JSONObjectForNextDays(tage)
    }

    //Macht aus einem EKEvent ein eventObject mit titel, startzeit und endzeit
    //eventObject:                {start:Uhrzeit, ende: Uhrzeit, titel: Eventtitel}

    func eventObjectForEvent(event: EKEvent) -> String
    {
        var eventString = "{"

        eventString += "\"titel\": \"\(event.title.stringByReplacingOccurrencesOfString("\"", withString: "\\\""))\","
        eventString += "\"start\": \"\(dateFormatterUhrzeit.stringFromDate(event.startDate))\","
        eventString += "\"ende\": \"\(dateFormatterUhrzeit.stringFromDate(event.endDate))\""

        eventString += "}"


        if(debuggingMode){
            print("Eventobjekt: \(eventString)")
        }
        return eventString
    }


    //Macht aus einem EKEvent-Array ein JSON Array
    //[eventObject1, eventObject2,...]

    func eventArrayForEvents(events:[EKEvent]) -> String
    {
        var eventArrayString = "["

        var firstEvent = true
        for event in events
        {
            //setze kein Komma falls das Objekt das Erste im Array ist
            if !firstEvent {eventArrayString += ","}
            else {firstEvent = false}
            eventArrayString += eventObjectForEvent(event)
        }

        eventArrayString += "]"

        return eventArrayString
    }

    //Macht aus Startdatum, Enddatum und EKCalendar ein calendarObject (leer falls keine Events vorhanden)
    //{Kalendertitel : [eventObject1, eventObject2,...]}

    func calendarObjectForStartDate(startDate: NSDate, endDate: NSDate, calendar: EKCalendar) -> String
    {
        var calendarObjectString: String

        //Legt ein Prädikat mit Startzeitpunkt, Endzeitpunkt und Kalender an
        let predicate = store.predicateForEventsWithStartDate( startDate,
            endDate: endDate,
            calendars: [calendar])

        //holt alle Events die dem Prädikat entsprechen
        let events = store.eventsMatchingPredicate(predicate)

        let eventArrayString = eventArrayForEvents(events)

        //Wenn leeres Array (keine Events vorhanden), gebe leeren String zurück
        if(eventArrayString == "[]")
        {
            calendarObjectString = ""
        }
        else
        {
            calendarObjectString = "{\"\(calendar.title)\":\(eventArrayString)}"
            //if(debuggingMode){print("Kalenderobjekt: \(calendarObjectString)")}
        }


        return calendarObjectString
    }

    //Liefert ein JSON Array aus calendarObjects
    //[calendarObject1, calendarObject2,...]

    func calendarArrayForDate(startDate: NSDate, endDate: NSDate,calendars:[EKCalendar]) -> String
    {
        var calendarArrayString = "["

        var firstCalendar = true
        for calendar in calendars
        {
            let calendarObject = calendarObjectForStartDate(startDate, endDate: endDate, calendar: calendar)


            if calendarObject != ""
            {
                if !firstCalendar{calendarArrayString += ","}
                else {firstCalendar = false}
                calendarArrayString += calendarObject
            }
        }

        calendarArrayString += "]"

        return calendarArrayString
    }


    //Liefert ein dateObject für ein Datum
    //dateObject:             {datum : [calendarObject1, calendarObject2,...]}
    func dateObjectForDate(date: NSDate) -> String
    {
        var dateObject = ""
        var startDate: NSDate

        //zerlegt übergebenes Datum und aktuellen Zeitpunkt in seine Komponenten
        let dateComponents = nsCalendar.components([.Year, .Month, .Day], fromDate: date)
        let todayComponents = nsCalendar.components([.Year, .Month, .Day], fromDate: NSDate())

        //Wenn das übergebene Datum heute ist, wähle aktuellen Zeitpunkt (also ab aktueller Uhrzeit) als Startzeitpunkt
        //Sonst wähle Tagesbeginn
        if(dateComponents == todayComponents)
        {
            startDate = date
        }
        else
        {
            startDate = nsCalendar.dateFromComponents(dateComponents)!
        }

        dateComponents.day += 1

        //Enddatum: Tagesende
        let endDate = nsCalendar.dateFromComponents(dateComponents)

        let calendarArray = calendarArrayForDate(startDate, endDate: endDate!, calendars: calendars)

        if (calendarArray == "[]")
        {
            dateObject = ""
        }
        else
        {
            dateObject = "{\"\(dateFormatterDatum.stringFromDate(date))\":\(calendarArrayForDate(startDate, endDate: endDate!, calendars: calendars))}"
            if(debuggingMode){print("Datumobjekt: \(dateObject)")}
        }
        return dateObject
    }

    //Liefert ein Array von dateObjects für die nächsten Tage
    //[dateObject1, dateObject2,...]

    func dateArrayForNextDays(numberOfDays:Int)->String
    {

        var dateArray = "["

        var firstDate = true;

        //Für kommende Tage beginnend mit heute
        for var day: Int = 0; day <= numberOfDays; day++
        {

            let date = NSDate().dateByAddingTimeInterval(NSTimeInterval(24*60*60*day))
            let dateObject = dateObjectForDate(date)

            if dateObject != ""
            {
                if !firstDate{dateArray += ","}
                else {firstDate = false}
                dateArray += dateObject
            }

        }

        dateArray += "]"
        return dateArray

    }

    //Liefert das finale JSON Objekt mit allen Events der nächsten Tage
    //{EventsForNextDays:[dateObject1, dateObject2,...]}

    func JSONObjectForNextDays(numberOfDays:Int)->String
    {
        return "{\"EventsForNextDays\":\(dateArrayForNextDays(numberOfDays-1))}"
    }

    func initializeParameters()
    {

        let arguments = Process.arguments

        if arguments.contains("-d") || arguments.contains("--debug")
        {
            debuggingMode = true
            print("debugging mode");
        }

        for var i = 0; i <= Process.arguments.count-1; i++
        {
            let argument = Process.arguments[i]
            if argument ==  "-t" || argument == "--tage"
            {
                tage = Int(Process.arguments[i+1])! //.toInt()!
                if (debuggingMode){print("Parameter: \(tage) Tage")}
            }
            else if argument == ("-i") || argument == "--include"
            {
                let include = Process.arguments[i+1]
                if (debuggingMode){print(include)}
                includeArray = include.componentsSeparatedByString(",")
            }
            else if argument == ("-e") || argument == ("--exclude")
            {
                let exclude = Process.arguments[i+1]
                if (debuggingMode){print(exclude)}
                excludeArray = exclude.componentsSeparatedByString(",")

            }
            else{()}

        }
    }


    func loadCalendars()
    {



        // Erfragt Zugang zu Entities vom Typ "Event" lokalen Store, gibt Erfolg in "granted: bool" zurück + evtl Fehlermeldung in "error: NSError"
        store.requestAccessToEntityType(EKEntityType.Event, completion: {
            granted, error in
        })

        let allCalendars = store.calendarsForEntityType(EKEntityType.Event)



        if includeArray.count != 0
        {
            for cal in allCalendars
            {
                for name in includeArray
                {
                    if name == cal.title
                    {
                        calendars.append(cal)
                    }
                }
            }
        }
        else
        {
            for cal in allCalendars
            {
                var shouldBeAdded = true
                for name in excludeArray
                {
                    if name == cal.title
                    {
                        shouldBeAdded = false
                    }
                }
                if(shouldBeAdded){calendars.append(cal)}
            }
        }

        if(debuggingMode)
        {
            print("Kalender geladen:")
            for cal in calendars
            {
                print(cal.title)
            }
        }
    }
}
///////////////////////////////////////////////////////////////////////////

var calTool = CalendarTool()

print(calTool.getJSON())






