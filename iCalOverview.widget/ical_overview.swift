//
//  main.swift
//  CalendarTool
//
//  Created by Benjamin Kunke on 04/11/14.
//  Improved by Daniel Kriesten
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
    let curCalendar = Calendar.current

    //Format für Datumsangaben
    var dateFormatterDatum : DateFormatter = DateFormatter()

    //Format für Uhrzeiten
    var dateFormatterUhrzeit : DateFormatter = DateFormatter()


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

    func eventObjectForEvent(_ event: EKEvent) -> String
    {
        var eventString = "{"

        eventString += "\"titel\": \"\(event.title.replacingOccurrences(of: "\"", with: "\\\""))\","
        eventString += "\"start\": \"\(dateFormatterUhrzeit.string(from: event.startDate))\","
        eventString += "\"ende\": \"\(dateFormatterUhrzeit.string(from: event.endDate))\""

        eventString += "}"


        if(debuggingMode){
            print("Eventobjekt: \(eventString)")
        }
        return eventString
    }


    //Macht aus einem EKEvent-Array ein JSON Array
    //[eventObject1, eventObject2,...]

    func eventArrayForEvents(_ events:[EKEvent]) -> String
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

    func calendarObjectForStartDate(_ startDate: Date, endDate: Date, calendar: EKCalendar) -> String
    {
        var calendarObjectString: String

        //Legt ein Prädikat mit Startzeitpunkt, Endzeitpunkt und Kalender an
        let predicate = store.predicateForEvents( withStart: startDate,
                                                  end: endDate,
                                                  calendars: [calendar])

        //holt alle Events die dem Prädikat entsprechen
        let events = store.events(matching: predicate)

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

    func calendarArrayForDate(_ startDate: Date, endDate: Date,calendars:[EKCalendar]) -> String
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
    func dateObjectForDate(_ date: Date) -> String
    {
        var dateObject = ""
        var startDate: Date

        //zerlegt übergebenes Datum und aktuellen Zeitpunkt in seine Komponenten
        var dateComponents = (curCalendar as NSCalendar).components([.year, .month, .day], from: date)
        let todayComponents = (curCalendar as NSCalendar).components([.year, .month, .day], from: Date())

        //Wenn das übergebene Datum heute ist, wähle aktuellen Zeitpunkt (also ab aktueller Uhrzeit) als Startzeitpunkt
        //Sonst wähle Tagesbeginn
        if(dateComponents == todayComponents)
        {
            startDate = date
        }
        else
        {
            startDate = curCalendar.date(from: dateComponents)!
        }

        dateComponents.day? += 1

        //Enddatum: Tagesende
        let endDate = curCalendar.date(from: dateComponents)

        let calendarArray = calendarArrayForDate(startDate, endDate: endDate!, calendars: calendars)

        if (calendarArray == "[]")
        {
            dateObject = ""
        }
        else
        {
            dateObject = "{\"\(dateFormatterDatum.string(from: date))\":\(calendarArrayForDate(startDate, endDate: endDate!, calendars: calendars))}"
            if(debuggingMode){print("Datumobjekt: \(dateObject)")}
        }
        return dateObject
    }

    //Liefert ein Array von dateObjects für die nächsten Tage
    //[dateObject1, dateObject2,...]

    func dateArrayForNextDays(_ numberOfDays:Int)->String
    {

        var dateArray = "["

        var firstDate = true;

        //Für kommende Tage beginnend mit heute
        var day = 0
        while day <= numberOfDays {
            let date = Date().addingTimeInterval(TimeInterval(24*60*60*day))
            let dateObject = dateObjectForDate(date)

            if dateObject != ""
            {
                if !firstDate{dateArray += ","}
                else {firstDate = false}
                dateArray += dateObject
            }
            day += 1
        }

        dateArray += "]"
        return dateArray

    }

    //Liefert das finale JSON Objekt mit allen Events der nächsten Tage
    //{EventsForNextDays:[dateObject1, dateObject2,...]}

    func JSONObjectForNextDays(_ numberOfDays:Int)->String
    {
        return "{\"EventsForNextDays\":\(dateArrayForNextDays(numberOfDays-1))}"
    }

    func initializeParameters()
    {

        let arguments = CommandLine.arguments

        if arguments.contains("-d") || arguments.contains("--debug")
        {
            debuggingMode = true
            print("debugging mode");
        }

        var argpos = 0
        while argpos <= CommandLine.arguments.count-1 {
            let argument = CommandLine.arguments[argpos]
            if argument ==  "-t" || argument == "--tage"
            {
                tage = Int(CommandLine.arguments[argpos+1])! //.toInt()!
                if (debuggingMode){print("Parameter: \(tage) Tage")}
            }
            else if argument == ("-i") || argument == "--include"
            {
                let include = CommandLine.arguments[argpos+1]
                if (debuggingMode){print(include)}
                includeArray = include.components(separatedBy: ",")
            }
            else if argument == ("-e") || argument == ("--exclude")
            {
                let exclude = CommandLine.arguments[argpos+1]
                if (debuggingMode){print(exclude)}
                excludeArray = exclude.components(separatedBy: ",")

            }
            else{()}
            argpos += 1

        }
    }


    func loadCalendars()
    {



        // Erfragt Zugang zu Entities vom Typ "Event" lokalen Store, gibt Erfolg in "granted: bool" zurück + evtl Fehlermeldung in "error: NSError"
        store.requestAccess(to: EKEntityType.event, completion: {
            granted, error in
        })

        let allCalendars = store.calendars(for: EKEntityType.event)



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
